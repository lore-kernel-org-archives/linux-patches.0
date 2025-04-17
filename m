Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5832C2571B4;
	Thu, 17 Apr 2025 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915019; cv=none; b=tUyKykUknaKOmbnqMgh6Alc7KapZ+XKcY04guVerFmpqcoIRvQJch685edoGoCKgE+AWDYXNfmnwCZQKOU7HtZOFZLpd0byNAvw1zaNwX6MOC2vZCn+V9DkK3nTu/koyjYBEbQnJYTZwirHAAy8Bkb/Nr4whk7GXV8bsqW/+RZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915019; c=relaxed/simple;
	bh=1g9ou7Kk6+F2jNMIAg3+VqWnqksFlH7/qlpArKXsADY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZLbvQRD92o/Bvo3Se4DSgbMjiWFLs9vNm8PvEyss/Db5pITlEdyvW0U743kru6/og1HyXzvlBrIBsDgHRlMSlcefD7Pvp7yrhV+5TZ6b/vbzyzb3f30kAOoHrUCMW9JupwK2TF59jRn/BSOfXxQjz1ZXFi50U6zUQl05yjFJwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqkpJa0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqkpJa0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75E6C4CEE4;
	Thu, 17 Apr 2025 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915019;
	bh=1g9ou7Kk6+F2jNMIAg3+VqWnqksFlH7/qlpArKXsADY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqkpJa0o+FBh3E02L4eyBVHnw/JZI2ohAy4UsU0WsBe469bvMjGywmLKybjWjRFf9
	 KJJTGi9WbgsW17BOlXmTfK3ppp38q7fHkwFcdqod0limi22iMma3N7/Ao1Tt3Up+Mi
	 lvD90XhkZTtq+Hl4u/iBFeStmIYg51R+jIiBFu9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.13 378/414] ntb: use 64-bit arithmetic for the MSI doorbell mask
Date: Thu, 17 Apr 2025 19:52:16 +0200
Message-ID: <20250417175126.662428198@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit fd5625fc86922f36bedee5846fefd647b7e72751 upstream.

msi_db_mask is of type 'u64', still the standard 'int' arithmetic is
performed to compute its value.

While most of the ntb_hw drivers actually don't utilize the higher 32
bits of the doorbell mask now, this may be the case for Switchtec - see
switchtec_ntb_init_db().

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 2b0569b3b7e6 ("NTB: Add MSI interrupt support to ntb_transport")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1353,7 +1353,7 @@ static int ntb_transport_probe(struct nt
 	qp_count = ilog2(qp_bitmap);
 	if (nt->use_msi) {
 		qp_count -= 1;
-		nt->msi_db_mask = 1 << qp_count;
+		nt->msi_db_mask = BIT_ULL(qp_count);
 		ntb_db_clear_mask(ndev, nt->msi_db_mask);
 	}
 


