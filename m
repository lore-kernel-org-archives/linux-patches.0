Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E13926ED5C;
	Tue, 11 Nov 2025 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824774; cv=none; b=Y07yeGn8J5AXig17QWyHNghKDUfH5mQlMLRjz2DNuxua7Mxd2i8dvq5l25UcUnl2nBceAggDQg7VCzqelfFaMGx6Q71PXMXEUNf4D3jiQtIxmMC+2SFltgXbaa6EtLjo98zzkRIdAxldQfO+/dSbLDgeEAggVcN3DevBF410UDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824774; c=relaxed/simple;
	bh=3rBEGN+CMzdHKgu8wuOc1GrCM5JU2xZgWVYZscfWOOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUhnBle9td+RT1LbvlVTOtS6HwjhwQPynlTKCm1DBuMsW4t1qCAJWt5tNIfAAf5gF1QzFobZdZltZdes62MAoJlz5VRlbX8HrQ3ks1kZRYMreduaMtdV9rz5+31ob5L0pt70OK9opVyZNHRNICdOAWVoSl4AlcDzXd/GCwDYU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcAEgd+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcAEgd+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A563AC16AAE;
	Tue, 11 Nov 2025 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824774;
	bh=3rBEGN+CMzdHKgu8wuOc1GrCM5JU2xZgWVYZscfWOOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcAEgd+meQdLulcsjkc3yeHHoGIx2sDm/V2MG7xdgtwB0KWu9R8HUcayYRTuOtNWF
	 BrjLRaxF6/Fuugt8yppSUiJh/SiEYuuJvbKSNR+WOZowJ/939o50yvGJ+Pd03NJDM3
	 mNPMKl+xySVilGiq6GscFHyWwDe5t7tGp8siOYcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 567/849] tools: ynl-gen: validate nested arrays
Date: Tue, 11 Nov 2025 09:42:17 +0900
Message-ID: <20251111004550.121440481@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 1d99aa4ed707c5630a7a7f067c8818e19167e3a1 ]

In nested arrays don't require that the intermediate attribute
type should be a valid attribute type, it might just be zero
or an incrementing index, it is often not even used.

See include/net/netlink.h about NLA_NESTED_ARRAY:
> The difference to NLA_NESTED is the structure:
> NLA_NESTED has the nested attributes directly inside
> while an array has the nested attributes at another
> level down and the attribute types directly in the
> nesting don't matter.

Example based on include/uapi/linux/wireguard.h:
 > WGDEVICE_A_PEERS: NLA_NESTED
 >   0: NLA_NESTED
 >     WGPEER_A_PUBLIC_KEY: NLA_EXACT_LEN, len WG_KEY_LEN
 >     [..]
 >   0: NLA_NESTED
 >     ...
 >   ...

Previous the check required that the nested type was valid
in the parent attribute set, which in this case resolves to
WGDEVICE_A_UNSPEC, which is YNL_PT_REJECT, and it took the
early exit and returned YNL_PARSE_CB_ERROR.

This patch renames the old nl_attr_validate() to
__nl_attr_validate(), and creates a new inline function
nl_attr_validate() to mimic the old one.

The new __nl_attr_validate() takes the attribute type as an
argument, so we can use it to validate attributes of a
nested attribute, in the context of the parents attribute
type, which in the above case is generated as:
[WGDEVICE_A_PEERS] = {
  .name = "peers",
  .type = YNL_PT_NEST,
  .nest = &wireguard_wgpeer_nest,
},

__nl_attr_validate() only checks if the attribute length
is plausible for a given attribute type, so the .nest in
the above example is not used.

As the new inline function needs to be defined after
ynl_attr_type(), then the definitions are moved down,
so we avoid a forward declaration of ynl_attr_type().

Some other examples are NL80211_BAND_ATTR_FREQS (nest) and
NL80211_ATTR_SUPPORTED_COMMANDS (u32) both in nl80211-user.c
$ make -C tools/net/ynl/generated nl80211-user.c

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250915144301.725949-7-ast@fiberby.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl-priv.h     | 10 +++++++++-
 tools/net/ynl/lib/ynl.c          |  6 +++---
 tools/net/ynl/pyynl/ynl_gen_c.py |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/lib/ynl-priv.h b/tools/net/ynl/lib/ynl-priv.h
index fca519d7ec9a7..ced7dce44efb4 100644
--- a/tools/net/ynl/lib/ynl-priv.h
+++ b/tools/net/ynl/lib/ynl-priv.h
@@ -106,7 +106,6 @@ ynl_gemsg_start_req(struct ynl_sock *ys, __u32 id, __u8 cmd, __u8 version);
 struct nlmsghdr *
 ynl_gemsg_start_dump(struct ynl_sock *ys, __u32 id, __u8 cmd, __u8 version);
 
-int ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr);
 int ynl_submsg_failed(struct ynl_parse_arg *yarg, const char *field_name,
 		      const char *sel_name);
 
@@ -467,4 +466,13 @@ ynl_attr_put_sint(struct nlmsghdr *nlh, __u16 type, __s64 data)
 	else
 		ynl_attr_put_s64(nlh, type, data);
 }
+
+int __ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr,
+			unsigned int type);
+
+static inline int ynl_attr_validate(struct ynl_parse_arg *yarg,
+				    const struct nlattr *attr)
+{
+	return __ynl_attr_validate(yarg, attr, ynl_attr_type(attr));
+}
 #endif
diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index 2a169c3c07979..2bcd781111d74 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -360,15 +360,15 @@ static int ynl_cb_done(const struct nlmsghdr *nlh, struct ynl_parse_arg *yarg)
 
 /* Attribute validation */
 
-int ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr)
+int __ynl_attr_validate(struct ynl_parse_arg *yarg, const struct nlattr *attr,
+			unsigned int type)
 {
 	const struct ynl_policy_attr *policy;
-	unsigned int type, len;
 	unsigned char *data;
+	unsigned int len;
 
 	data = ynl_attr_data(attr);
 	len = ynl_attr_data_len(attr);
-	type = ynl_attr_type(attr);
 	if (type > yarg->rsp_policy->max_attr) {
 		yerr(yarg->ys, YNL_ERROR_INTERNAL,
 		     "Internal error, validating unknown attribute");
diff --git a/tools/net/ynl/pyynl/ynl_gen_c.py b/tools/net/ynl/pyynl/ynl_gen_c.py
index eb295756c3bf7..6e3e52a5caaff 100755
--- a/tools/net/ynl/pyynl/ynl_gen_c.py
+++ b/tools/net/ynl/pyynl/ynl_gen_c.py
@@ -828,7 +828,7 @@ class TypeArrayNest(Type):
         local_vars = ['const struct nlattr *attr2;']
         get_lines = [f'attr_{self.c_name} = attr;',
                      'ynl_attr_for_each_nested(attr2, attr) {',
-                     '\tif (ynl_attr_validate(yarg, attr2))',
+                     '\tif (__ynl_attr_validate(yarg, attr2, type))',
                      '\t\treturn YNL_PARSE_CB_ERROR;',
                      f'\tn_{self.c_name}++;',
                      '}']
-- 
2.51.0



