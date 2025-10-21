Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03042350A0D;
	Tue, 21 Oct 2025 20:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077212; cv=none; b=C0NJVVCyo3s12W3+V1mKjeYtkyBQrgHd8jFElVsg4o99OYOZyd4FXrQqyDHG1VFwx5yAeIFQ+Kw7NSLQUILJrgBPjwoSgRy5FUevpzwGLBsZQ7GtRM03LOzpaJRvrdMyMzZ9dYTUzi4BVwhpR4hzHEeXQOsI3HWM+FmdUNyY0SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077212; c=relaxed/simple;
	bh=ZOz032bR4CMoMXOdjkjwYTsmcDBHpJMsfilyRtNicPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwvKU6aumNOa/VISecvqIAB7tgyIbf6es4yvYZyHL5YwpnrfJrqOGyt/cJUym0YZ4lT2JMaHFbpofIcHOdo76iO+NlwoM1TpQteIV3gc6+gL5aUuEL+ZLKuo/OvIujdaUDEFRR4vdkia7RtHeiW9OVyGIjXoBd59OtsZrQ1LdK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUMW1dqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUMW1dqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E08C4CEF1;
	Tue, 21 Oct 2025 20:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077211;
	bh=ZOz032bR4CMoMXOdjkjwYTsmcDBHpJMsfilyRtNicPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUMW1dqQRwgcp1Tnb1S7r56HCrbYeBS7HGhHzt/zoYnDK9ZEVlCKhgydz2frjfsbx
	 lyYnnTICndL2tKCc0Dklx1bqn3fd/oAKsmoe2gZEz3RqJKQVvkD05s+VFW1my1jOzH
	 LDtmJ6v0R0r2t/X/aHbAJKf27HscjXPiw/UDRkxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Korenevsky <ekorenevsky@aliyun.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 033/159] cifs: parse_dfs_referrals: prevent oob on malformed input
Date: Tue, 21 Oct 2025 21:50:10 +0200
Message-ID: <20251021195043.994576943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Korenevsky <ekorenevsky@aliyun.com>

commit 6447b0e355562a1ff748c4a2ffb89aae7e84d2c9 upstream.

Malicious SMB server can send invalid reply to FSCTL_DFS_GET_REFERRALS

- reply smaller than sizeof(struct get_dfs_referral_rsp)
- reply with number of referrals smaller than NumberOfReferrals in the
header

Processing of such replies will cause oob.

Return -EINVAL error on such replies to prevent oob-s.

Signed-off-by: Eugene Korenevsky <ekorenevsky@aliyun.com>
Cc: stable@vger.kernel.org
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -916,6 +916,14 @@ parse_dfs_referrals(struct get_dfs_refer
 	char *data_end;
 	struct dfs_referral_level_3 *ref;
 
+	if (rsp_size < sizeof(*rsp)) {
+		cifs_dbg(VFS | ONCE,
+			 "%s: header is malformed (size is %u, must be %zu)\n",
+			 __func__, rsp_size, sizeof(*rsp));
+		rc = -EINVAL;
+		goto parse_DFS_referrals_exit;
+	}
+
 	*num_of_nodes = le16_to_cpu(rsp->NumberOfReferrals);
 
 	if (*num_of_nodes < 1) {
@@ -925,6 +933,15 @@ parse_dfs_referrals(struct get_dfs_refer
 		goto parse_DFS_referrals_exit;
 	}
 
+	if (sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3) > rsp_size) {
+		cifs_dbg(VFS | ONCE,
+			 "%s: malformed buffer (size is %u, must be at least %zu)\n",
+			 __func__, rsp_size,
+			 sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3));
+		rc = -EINVAL;
+		goto parse_DFS_referrals_exit;
+	}
+
 	ref = (struct dfs_referral_level_3 *) &(rsp->referrals);
 	if (ref->VersionNumber != cpu_to_le16(3)) {
 		cifs_dbg(VFS, "Referrals of V%d version are not supported, should be V3\n",


