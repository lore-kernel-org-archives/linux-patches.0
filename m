Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1A9341ABD;
	Tue, 26 Aug 2025 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216513; cv=none; b=ZAy2rtpPLa8pk2acoDsphO/CK08P/c2RBIVz66M+VFtpolTJjIh1AqYrsDHXM5C9IvGd5SbNHmtswJ0qrgTkD0naCQ3aDneedtlhasVx8+0skJhEBhWVqeJqlsMUl2HUA3HVn6BYZhASOWprflq407ssP2r8qg++HgAXsSXRc/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216513; c=relaxed/simple;
	bh=/S5VpeP4nuCXC5YYjSSn8H6j5Z3/jGMEjnyUvDcnAvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMonWUSjObG+mjUBLlEP9vDLnf8GWxN9zfZWK/E/tLDMKGYDi7H+IzYKwg2evCaW2PumVQaOjO5mWhIQqWJoiKLYjUsimpUhBk4UhR+9hKK/objni4gDI15NqBQMO301NnoEE9gMosFlxMpPM4022QbAXUrBg6Up6Zptr44I7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZd/Das0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZd/Das0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2536C113CF;
	Tue, 26 Aug 2025 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216513;
	bh=/S5VpeP4nuCXC5YYjSSn8H6j5Z3/jGMEjnyUvDcnAvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZd/Das09N5fGP7LcT+FbUflJ1oc/6Wh/I31ULAXgvL8MEGiSTzPnGzMphtBrwatp
	 ADTH+x4g9yWmGd+3N8hZOD2lhD2KwD26VIH1AH6bY4zxbjgN3qBoFS/wwSiAMTlJZY
	 37gt/79oIgt8uAt1otFI20NE0aOGjWZtGesNM4io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/644] scsi: bfa: Double-free fix
Date: Tue, 26 Aug 2025 13:08:03 +0200
Message-ID: <20250826110956.158414183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: jackysliu <1972843537@qq.com>

[ Upstream commit add4c4850363d7c1b72e8fce9ccb21fdd2cf5dc9 ]

When the bfad_im_probe() function fails during initialization, the memory
pointed to by bfad->im is freed without setting bfad->im to NULL.

Subsequently, during driver uninstallation, when the state machine enters
the bfad_sm_stopping state and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again, thereby
triggering a double-free vulnerability.

Set bfad->im to NULL if probing fails.

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6b5841b1c06e..38292bc43d91 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -707,6 +707,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.39.5



