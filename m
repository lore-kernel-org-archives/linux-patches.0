Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC2915AAA8;
	Mon, 29 Jan 2024 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548159; cv=none; b=X0w4l6KNQrYRp0X8FHdDQ3uKDGKZL9kNQhbvgg9ygJ5TH67WhZQAb1VAMY1Ax9Ga0LkxD2mybqpwJIC1f1usJf6szruEtGwK/bWgGPGfDf6c4Uey+d/fU3nO3DOrDyyDgvkMaSay0eklTmZnlQTVCTg0ndFymuOHyvBHg0VyeUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548159; c=relaxed/simple;
	bh=9dLS3l6JyYwur2YW7u4ICBNsURxX79X2iGOVAg92b4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdgSAY/FBhPAwi23XbQudKhfP9GLo10q1OmNzx0iguAvS2yNBMfWgD8XqUGC1lbntjcbjoy/PNubEBYVUUMOsM9hSxn8jLmatRqF/Q2iaDs/fuoT0KnQOsS23jEklV4BDpQBLKCJUtUnbOSCjTbOux7/3ZkM1pG82a0+AqZtB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecom0Uw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecom0Uw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FDDC43394;
	Mon, 29 Jan 2024 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548159;
	bh=9dLS3l6JyYwur2YW7u4ICBNsURxX79X2iGOVAg92b4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecom0Uw0HJbqpvNy0tRlGZBctB3jd5HgjvVK795rcDfaV8K0/VHryaUj1ztsM1bm7
	 U8RWfflG7WAuZjDBerAQT7m6wlpwOS13DKOBvMdxKyQK3MjiCLUUl964wYF5KNfQYH
	 YoSt0rRA6l4FLNozdoXfXR3tHNfkWMDwmlOAB1I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 174/346] afs: Handle the VIO and UAEIO aborts explicitly
Date: Mon, 29 Jan 2024 09:03:25 -0800
Message-ID: <20240129170021.512927735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit eb8eae65f0c713bcef84b082aa919f72c3d83268 ]

When processing the result of a call, handle the VIO and UAEIO abort
specifically rather than leaving it to a default case.  Rather than
erroring out unconditionally, see if there's another server if the volume
has more than one server available, otherwise return -EREMOTEIO.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Stable-dep-of: 17ba6f0bd14f ("afs: Fix error handling with lookup via FS.InlineBulkStatus")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rotate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/afs/rotate.c b/fs/afs/rotate.c
index 59aed7a6dd11..a108cd55bb4e 100644
--- a/fs/afs/rotate.c
+++ b/fs/afs/rotate.c
@@ -330,6 +330,13 @@ bool afs_select_fileserver(struct afs_operation *op)
 
 			goto restart_from_beginning;
 
+		case UAEIO:
+		case VIO:
+			op->error = -EREMOTEIO;
+			if (op->volume->type != AFSVL_RWVOL)
+				goto next_server;
+			goto failed;
+
 		case VDISKFULL:
 		case UAENOSPC:
 			/* The partition is full.  Only applies to RWVOLs.
-- 
2.43.0



