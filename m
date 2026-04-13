Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E5D3161AB;
	Mon, 13 Apr 2026 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098985; cv=none; b=tI5MJaypQxMJUdgPu1eQ3ERs5KaFMLYB1FPglU5ufo0l1uTKajpCMxO1D/SClLV9oXyJNAWeDqytownvgAqPwy0rWIal2ix8A5RTV7/5RsXWJ13h+j2LapZ2GxTQJRzIXrFRPfXWddXWUmGUMOHzq6EpMI3jvfj0lqAdHkHZsks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098985; c=relaxed/simple;
	bh=/LinhuZ/PQou2k6cYHviMoMXo1ERt5HRVPcIfSL1kEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V17ezwxv/DKb74u+P87wsJSpKBBiji1o+UmwXYuzexoTMGxYdZX80PltWG41ie+By7w/TkWnxrkEPP7h9z/8eWGbSDOnZRqG1p3r0EHsSTHFFcNQAFWwD/akCl5+U4nOf+z5a2qXeqMAJis2Y1FKZwWZOUd2BSTjziQ016lbMZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAnE/+50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAnE/+50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C1CC2BCAF;
	Mon, 13 Apr 2026 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098985;
	bh=/LinhuZ/PQou2k6cYHviMoMXo1ERt5HRVPcIfSL1kEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAnE/+50Uz4OVaMqDKZO2zIeYjHswxc5/LCP4AIW5Qny+Z/Z4JXyYRt8mo4A2e6/7
	 lDPpMiBeiz+fMHLX8AkpQWkiTm13nIa4GBHAbm+9xi3yaZOPPh0x03EY1sw84uFlm1
	 X0tihEKw8WF5qGa6cK0Qlr3Azd4znxYrYl7xrM6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/491] smb: client: Dont log plaintext credentials in cifs_set_cifscreds
Date: Mon, 13 Apr 2026 17:56:50 +0200
Message-ID: <20260413155825.217017045@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 2f37dc436d4e61ff7ae0b0353cf91b8c10396e4d ]

When debug logging is enabled, cifs_set_cifscreds() logs the key
payload and exposes the plaintext username and password. Remove the
debug log to avoid exposing credentials.

Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2951,7 +2951,6 @@ cifs_set_cifscreds(struct smb_vol *vol,
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);


