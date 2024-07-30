Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CF3161901;
	Tue, 30 Jul 2024 17:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358838; cv=none; b=cUMMEJUxDqcQ9odXM7SklqNKUsQixLgRkShRlRwx3rTmA55FVLMvBiv77eSW6fJ6Q16InUGyw3ZZuSoMIwAVQtSm1YH5IGvjasVV6ECL4BjCfZ21N+/uB3UtqUpGvqW5qST5WcyojxSoRsLiRGQJ3Nr2K3jwtc25KJpNKmphHGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358838; c=relaxed/simple;
	bh=nqmALTEx261NS8LkCpSTQ8S9NEFqjnf6MfcEnLodOSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COvW2e6XCw+UZJUL1REpqdcj7uhfyAvi4ZilA3R1J8cSZTW3rarukAyBgdjKND1kcURqblGaOCXxiUDMpI/CEYc/o/5+gFRixbvlehaxu+aoI10PCnkg1FuRuO9TjiGhRMDUEFL5qPYWjJvoA3b2PU3cpVuJADP/KxaENzAvvuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kk7dCuqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kk7dCuqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8591C32782;
	Tue, 30 Jul 2024 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358838;
	bh=nqmALTEx261NS8LkCpSTQ8S9NEFqjnf6MfcEnLodOSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk7dCuqxl47Kmt/Q30DM6AxWNXfZ+uZh+M6t+9bo+5QEfTCEprbvv3xbj+LLoG1Pw
	 nG2wJv2eeRgWZx+2p0P/N+8wNySu0BqZKEZIM0r3YWxZNwKCrOSo5g7J1hzE5B7ARx
	 u2/v6RTkmoJIBYfgC5q9+sstz6fGXrySDMCnX+5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowell@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 392/568] cifs: mount with "unix" mount option for SMB1 incorrectly handled
Date: Tue, 30 Jul 2024 17:48:19 +0200
Message-ID: <20240730151655.185195609@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 0e314e452687ce0ec5874e42cdb993a34325d3d2 upstream.

Although by default we negotiate CIFS Unix Extensions for SMB1 mounts to
Samba (and they work if the user does not specify "unix" or "posix" or
"linux" on mount), and we do properly handle when a user turns them off
with "nounix" mount parm.  But with the changes to the mount API we
broke cases where the user explicitly specifies the "unix" option (or
equivalently "linux" or "posix") on mount with vers=1.0 to Samba or other
servers which support the CIFS Unix Extensions.

 "mount error(95): Operation not supported"

and logged:

 "CIFS: VFS: Check vers= mount option. SMB3.11 disabled but required for POSIX extensions"

even though CIFS Unix Extensions are supported for vers=1.0  This patch fixes
the case where the user specifies both "unix" (or equivalently "posix" or
"linux") and "vers=1.0" on mount to a server which supports the
CIFS Unix Extensions.

Cc: stable@vger.kernel.org
Reviewed-by: David Howells <dhowell@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2614,6 +2614,13 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 			cifs_dbg(VFS, "Server does not support mounting with posix SMB3.11 extensions\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
+		} else if (ses->server->vals->protocol_id == SMB10_PROT_ID)
+			if (cap_unix(ses))
+				cifs_dbg(FYI, "Unix Extensions requested on SMB1 mount\n");
+			else {
+				cifs_dbg(VFS, "SMB1 Unix Extensions not supported by server\n");
+				rc = -EOPNOTSUPP;
+				goto out_fail;
 		} else {
 			cifs_dbg(VFS,
 				"Check vers= mount option. SMB3.11 disabled but required for POSIX extensions\n");


