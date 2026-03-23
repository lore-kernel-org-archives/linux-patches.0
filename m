Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAC13A961B;
	Mon, 23 Mar 2026 13:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273840; cv=none; b=S42Yd7bo3vKm78NjyT54wNQvgrMTTrNCamEnr4ravc94OgsX/lKgsFOibqgu6tVqJWLb8b2Mvxl/HuBBOSWgO0QIprYR6dBiM/C1ug8TdHNp8XHuJ1cDvSaW/W2vY5VpXp4kEITbGsZWBw6GVpLdh+8Cn+JsBzvDC5fnTKV8BAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273840; c=relaxed/simple;
	bh=46lBygGMgGqLbhq0M/K0jsMNu6y2g6KmWkcPM3N9fU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Viw/ASRSf3IW+/gR8YhuxGd9YiFURkFPCuC6yIVWA1TFpjU8fBO3dwp9GS6wb1kWUY4GJ4RAunnd00z4bATUiVWGYovd/lRqO93aL1aWdUhgWPtLkPpd+x3neXhQ/f1zv8/1rMHw7vfBmsuwarItptGAq8W498NCLSUdAPkm0zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiEeDJsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiEeDJsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F186C2BC9E;
	Mon, 23 Mar 2026 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273840;
	bh=46lBygGMgGqLbhq0M/K0jsMNu6y2g6KmWkcPM3N9fU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiEeDJsDn5v3orNPBgYJoBuEPYPq+XhSGPaswFmXb0n1QW80Dn7zgVy2f+bj+6Fqs
	 /9NcNcyutEOBLgaUe9GxWrPpJ3z8RxpmEMmw+gsagQuIYUFDQmu3rLgq+UfeBK3ZoD
	 2L5jfkvHXVvJJcRdxH3EQ4YjInps0SX+qjb3jFh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 025/220] ksmbd: unset conn->binding on failed binding request
Date: Mon, 23 Mar 2026 14:43:22 +0100
Message-ID: <20260323134505.376368578@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 282343cf8a4a5a3603b1cb0e17a7083e4a593b03 upstream.

When a multichannel SMB2_SESSION_SETUP request with
SMB2_SESSION_REQ_FLAG_BINDING fails ksmbd sets conn->binding = true
but never clears it on the error path. This leaves the connection in
a binding state where all subsequent ksmbd_session_lookup_all() calls
fall back to the global sessions table. This fix it by clearing
conn->binding = false in the error path.

Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1947,6 +1947,7 @@ out_err:
 			}
 		}
 		smb2_set_err_rsp(work);
+		conn->binding = false;
 	} else {
 		unsigned int iov_len;
 


