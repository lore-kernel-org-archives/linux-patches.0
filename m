Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5033093C1;
	Sat, 25 Oct 2025 16:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409746; cv=none; b=IU2J3Fg7DdVRUj5xOPXnnCjRSewDi0cUByUcS7oGxAGME6ecP1oiWoGSxN6neLL0V9N7i1FtJlLBxigX3H94ipPjZnBC9BdTjg9ZO9mx4yPojnMI9h5INpKkYY21weNy7fLm7I3AKDx3ef9q9GvV6XLT/tkYGuJHSuXovlJgXBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409746; c=relaxed/simple;
	bh=BeezYbCEOBmnB79C4JVmST8jP0WZOGRDAnHrCYYKSbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6yfjFLtpE7GGmXfSIITTAn51AbWeDvma/LxOcA6s4J5pI9reed/qoPr2WXel3scoYqHTt6/FtI0/pR8tqBk4V2yjhXgaMajXw8BgbDquNPoCMRYwBId4qgjN0pn8fngPllLOkcDU4rbWEWUTRFX1t3GzPh8s4ZQ+XHkNNBul+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKzDFzRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKzDFzRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D59C4CEFB;
	Sat, 25 Oct 2025 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409746;
	bh=BeezYbCEOBmnB79C4JVmST8jP0WZOGRDAnHrCYYKSbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKzDFzRwss08oOjJgk3e0eQX1ooJ/7N2kTBl7/SCYJuKY9Fb9mdRMlsesJ7T9WFpP
	 ZKFltIAbv8hZh4zWcEY0Ka0imwA98JLxcKO4lM2FqGAHlf+PvP4CIAprG/DTGj7Re/
	 hGWi63LrWlBau50rytJEgvhAV+LCULQF0Oj24YmOtS+H01uGJFCmkTQc0SbqZ+5psc
	 T9WGEXnAM8j7nwtNqlk7KTic7Qr+OS6qPG358hQIrldLWVxUkWjxLOg8K6z7+vMPqH
	 ceC9jz0137iUbX35ECdoJ1ylFEOmxVq6T92AEJnc0h6AKOeZlpcycC3EZP1NWxeMoQ
	 tr/2P6TfSE7hQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	donald.hunter@gmail.com,
	jacob.e.keller@intel.com,
	pabeni@redhat.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	dw@davidwei.uk,
	matttbe@kernel.org,
	sdf@fomichev.me
Subject: [PATCH AUTOSEL 6.17] tools: ynl-gen: validate nested arrays
Date: Sat, 25 Oct 2025 12:01:17 -0400
Message-ID: <20251025160905.3857885-446-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- The previous validator assumed each nested element’s `nla_type` was
  meaningful, so arrays such as `WGDEVICE_A_PEERS` hit the
  `YNL_PT_REJECT` guard and aborted with `YNL_PARSE_CB_ERROR`. The new
  helper in `tools/net/ynl/lib/ynl.c:363` keeps the existing length
  checks but lets callers supply the policy index explicitly, avoiding
  that false rejection.
- To preserve every current caller, `tools/net/ynl/lib/ynl-
  priv.h:473-477` adds an inline wrapper that still derives the type
  from the attribute, so there is no behavioural change outside the one
  new call site.
- The generator now feeds the parent attribute’s type into the validator
  when iterating array members
  (`tools/net/ynl/pyynl/ynl_gen_c.py:833-838`), using the index captured
  earlier in the loop (`tools/net/ynl/pyynl/ynl_gen_c.py:2177`). That
  matches the documented `NLA_NESTED_ARRAY` semantics where the per-
  element type value is irrelevant, yet still enforces the payload
  length (u32, nest, etc.) dictated by the policy.

This is a clear bug fix: without it, any generated YNL client fails to
consume nested-array replies (WireGuard peers, NL80211 command lists,
etc.), which is a real regression for users of the new nested-array
support. The change is small, fully contained in `tools/net/ynl/`,
introduces no ABI shifts, and keeps existing helpers intact, so
regression risk is minimal. Stable trees that already carry the nested-
array support patches should pick this up; no additional dependencies
beyond that series are required. If you want extra assurance, you can
regenerate one of the affected users (`make -C tools/net/ynl/generated
nl80211-user.c`) after applying the patch.

 tools/net/ynl/lib/ynl-priv.h     | 10 +++++++++-
 tools/net/ynl/lib/ynl.c          |  6 +++---
 tools/net/ynl/pyynl/ynl_gen_c.py |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/lib/ynl-priv.h b/tools/net/ynl/lib/ynl-priv.h
index 824777d7e05ea..29481989ea766 100644
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

