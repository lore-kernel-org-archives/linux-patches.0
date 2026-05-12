Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151CE21FF21;
	Tue, 12 May 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607934; cv=none; b=hkY2bjCpC/NJTEn2UlDxYu70PpbBeVgrZqfLMmYlAGsyo8fAQezcthNoGvkqLssus+YldMSJ3YQkU+9SBILozhcN8Dy56uErtaVtyfiLhzB1fDxfZ7iov4ovvEGH78sV4xbEID1i+9lA4wLeXlFF41071/8gfrxRpSXKSw7tVsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607934; c=relaxed/simple;
	bh=BiOSI3Q0Fc4wk3o9MbO+6XyT6Nj7DUPg2wSiGZQlmfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpmGxtCUtsyPTRy5LygS98EtK1/4LLsx89DR8gCMgbxMxgo1u0CMjoFyr55cVueiIAaII4JsL+v3BehyER4GwAYOP6L9gUXDCjfnN63rtOLwSvAXrVOE1ajnuluIYgxid/sw70MQZg/D11diDeyyKB6z7X/VIvRWTW2y9G0y+NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIVdZRJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIVdZRJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BF9C2BCB0;
	Tue, 12 May 2026 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607933;
	bh=BiOSI3Q0Fc4wk3o9MbO+6XyT6Nj7DUPg2wSiGZQlmfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIVdZRJBab3QUHLMx/XRQwjtroDhypHvuAa72qx1PdSlgBFflvXf8no9aHZ+3FYkL
	 /irQFZFDMVjJwi1L4lgvRHkenBv5Ld5fxYaWBz1CVy6qK1QrxSlmoepZwwKLnB+k/N
	 jNOD4zbvBAV3yGBCJYat/q0IZIlQa6imDkqSzpxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 091/206] cifs: abort open_cached_dir if we dont request leases
Date: Tue, 12 May 2026 19:39:03 +0200
Message-ID: <20260512173934.783583687@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit d68ce834f8cf6cb2e77f3331df65166b35466b53 upstream.

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -261,6 +261,14 @@ replay_again:
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "%s: Oplock level %d not suitable for cached directory\n",
+			 __func__, oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));


