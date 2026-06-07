Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9DD1E98EF;
	Sun,  7 Jun 2026 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827184; cv=none; b=ewboY7WlpnrWQlzzTZEFX/AezPgCrNUd3I3R7FQ6vfIWpx12wYnvdLRLKbTYQ0JQO4ugNX9f2vQuqE2ZqbSYkUSRQoYmv7rfB6UvXp0p461ZwXC5oOimoolALg6t7txyEYXMBkHw1zBU83Z5zk2m8ECm+ZkY8hFNsEGNTJAp4us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827184; c=relaxed/simple;
	bh=NmYRxyiyJdyUBwmBWdw4zVY196GCMrfa2M78SNNyNH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxQhOSmUD6GKZvLZo9gIjEWknHDcYc7kuCB9XLSrE+qUyPr0XP0k1rdf8/RYVn/rdant9AlXisd6Fcq9eQRVGJP4LdC91ou0VCz4UIESRKACDORRMBQlWwFttehSp55ikxDMn6h2H6gptI9q6Eeu9Zen6ftpIztMKn1XFMMoNZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAAcNV2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAAcNV2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFE71F00893;
	Sun,  7 Jun 2026 10:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827183;
	bh=ZEIevUBB+GCT5uj4JAJ4H8bpv8Hdm7YWDdLTey0OZgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAAcNV2VT47Ae1AxvnS9FVPJ/yOVHXM1yiFPShZBsP9AtG4frcHXqmzty9rGYOPCT
	 Ve/ikO2EQLSkHQ+bePqzcTvz10hVJu1MhtVEr38YOEMilqpw0h3bACsSTfhcKp9vPr
	 W4LLJAyxVSS6m4daJa4xFxIPKkLMEtuU8zOjWTWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 052/332] ethtool: cmis: require exact CDB reply length
Date: Sun,  7 Jun 2026 11:57:01 +0200
Message-ID: <20260607095730.034192303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6c3f999a9d1338c6c89a9ff4549eafe72bc2e7b1 ]

Malicious SFP module could respond with rpl_len longer than
what cmis_cdb_process_reply() expected, leading to OOB writes.
Malicious HW is a bit theoretical but some modules may just
be buggy and/or the reads may occasionally get corrupted,
so let's protect the kernel.

The existing check protects from short replies. We need to
protect from long ones, too. All callers that pass a non-zero
rpl_exp_len cast the reply payload to a fixed-layout struct
and read fields at fixed offsets, with no version negotiation
or short-reply handling:

  - cmis_cdb_validate_password()
  - cmis_cdb_module_features_get()
  - cmis_fw_update_fw_mng_features_get()

so let's assume that responses longer than expected do not
have to be handled gracefully here. Add a warning message
to make the debug easier in case my understanding is wrong...

Note that page_data->length (argument of kmalloc) comes from
last arg to ethtool_cmis_page_init() which is rpl_exp_len.

Note2 that AIs also like to point out overflows in args->req.payload
itself (which is a fixed-size 120 B buffer, on the stack),
but callers should be reading structs defined by the standard,
so protecting from requests for more data than max seem like
defensive programming.

Fixes: a39c84d79625 ("ethtool: cmis_cdb: Add a layer for supporting CDB commands")
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-7-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis_cdb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/cmis_cdb.c b/net/ethtool/cmis_cdb.c
index 3670ca42dd403e..f3a53a98446099 100644
--- a/net/ethtool/cmis_cdb.c
+++ b/net/ethtool/cmis_cdb.c
@@ -513,8 +513,13 @@ static int cmis_cdb_process_reply(struct net_device *dev,
 	}
 
 	rpl = (struct ethtool_cmis_cdb_rpl *)page_data->data;
-	if ((args->rpl_exp_len > rpl->hdr.rpl_len + rpl_hdr_len) ||
-	    !rpl->hdr.rpl_chk_code) {
+	if (rpl->hdr.rpl_len != args->rpl_exp_len) {
+		netdev_warn(dev, "CDB reply length mismatch, expected %u got %u\n",
+			    args->rpl_exp_len, rpl->hdr.rpl_len);
+		err = -EIO;
+		goto out;
+	}
+	if (!rpl->hdr.rpl_chk_code) {
 		err = -EIO;
 		goto out;
 	}
-- 
2.53.0



