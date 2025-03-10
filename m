Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F95522D799;
	Mon, 10 Mar 2025 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628300; cv=none; b=LxEV+p+/s3mi3kSZ3dXxG/ZzcTrBIVKjQprBBJf6rGjoi++e59yZJToCwwZeJu00fueALsIyPPJPjxcrKvWsn448jN/csno8e1j6YS04v7NPBzniHDJ/k9lAp6tbZ1D1ziARe0uFQt85n5mVEZOZs59p0ac0f2pwQUa9q93n+/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628300; c=relaxed/simple;
	bh=YJXgXAS5rpApPSlrwukVySK04M3S88Gx6v2fjCyJKIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJT/DQsiDygHn2MRPdab/HZLctbSKLWgnWdQDWHg+VhpNcprK8ytm/oOuY8r/76APM0ZW6lzTGzSuben9aMAFXfw052QCyJMmC/4GEhRY988O48s8uF/OOAaPTVkW5iNjpwzYusluvwSt/Z+K8Yxc21Qqymnb/Dfs9kbdxkTO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E14NAExU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E14NAExU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD489C4CEE5;
	Mon, 10 Mar 2025 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628300;
	bh=YJXgXAS5rpApPSlrwukVySK04M3S88Gx6v2fjCyJKIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E14NAExUq9Qhm75u08GIPTOXGRxJv+Xtr7Bug/tBAonaHe8WQkpA0CMamIqbik/yl
	 8vQ+Qxr4MYhxm9ikeyxHZlDT8X0JdvYuwPo+/kJtrfSdP5VZ1z5aTAh8IgwlSmT+N4
	 /LnDq1rkW4E2WbU9FDsZDShBAvHNEbn0tDhdHrKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 011/109] ksmbd: fix type confusion via race condition when using ipc_msg_send_request
Date: Mon, 10 Mar 2025 18:05:55 +0100
Message-ID: <20250310170428.000676003@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit e2ff19f0b7a30e03516e6eb73b948e27a55bc9d2 upstream.

req->handle is allocated using ksmbd_acquire_id(&ipc_ida), based on
ida_alloc. req->handle from ksmbd_ipc_login_request and
FSCTL_PIPE_TRANSCEIVE ioctl can be same and it could lead to type confusion
between messages, resulting in access to unexpected parts of memory after
an incorrect delivery. ksmbd check type of ipc response but missing add
continue to check next ipc reponse.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -267,6 +267,7 @@ static int handle_response(int type, voi
 		if (entry->type + 1 != type) {
 			pr_err("Waiting for IPC type %d, got %d. Ignore.\n",
 			       entry->type + 1, type);
+			continue;
 		}
 
 		entry->response = kvzalloc(sz, GFP_KERNEL);


