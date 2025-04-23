Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB47E283CBE;
	Wed, 23 Apr 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421204; cv=none; b=uENXWrAc70KYfshwsYigKpPk47koYfaG4FxXB8ZK8t0EK3H+R8x9BbH8Xcjln9/ry5p0SSHS9IS8Y111uO7oao01IqNJLaWb+4DUWRx8bQ3yOoV/0DUn0UE5GNz9iKGd8xxFg5bv4RUm9+wZJw5c58wpyRCfoqi96csgq2/Fcko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421204; c=relaxed/simple;
	bh=2Xt6SHWXWL7JEl1tfSH6pwsJwjSaH9XbvSU0c4f2Nh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7LKNH/cxpKRUwAUycjyUJ5sJB1/ewrprL5vuBFa3AvdxzfG2t/+JLXYfq0qZch8ENLTZislkEt8oEH7y58dCa2YqgfFJ7p01bcRokvqaEUs+B1PcTNNSrZ5r9t9jPbEJxnYEmeH/zyd2VnAz4NKVhRqlHA/G+fbcNUwyrYNDwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVXgQVsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVXgQVsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D643C4CEE2;
	Wed, 23 Apr 2025 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421204;
	bh=2Xt6SHWXWL7JEl1tfSH6pwsJwjSaH9XbvSU0c4f2Nh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVXgQVsPhMOV+jjlOl8sU9afNDpUl9kChM+dJPncFSAQ0ghVpXQeX7zT+Xq0R52Iv
	 FFlJUqjWaWLcwd7D9Ov0fJ1+36RjW6tUTwfL+dUM4eHpyokbHYQ1BTNNtuAO0vOKEk
	 XDzZasi05paQ8JXPEDECA8xMYzAALd0JcZFOHVbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 117/291] i3c: master: svc: Use readsb helper for reading MDB
Date: Wed, 23 Apr 2025 16:41:46 +0200
Message-ID: <20250423142629.166352604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Stanley Chu <yschu@nuvoton.com>

commit c06acf7143bddaa3c0f7bedd8b99e48f6acb85c3 upstream.

The target can send the MDB byte followed by additional data bytes.
The readl on MRDATAB reads one actual byte, but the readsl advances
the destination pointer by 4 bytes. This causes the subsequent payload
to be copied to wrong position in the destination buffer.

Cc: stable@kernel.org
Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -368,7 +368,7 @@ static int svc_i3c_master_handle_ibi(str
 	       slot->len < SVC_I3C_FIFO_SIZE) {
 		mdatactrl = readl(master->regs + SVC_I3C_MDATACTRL);
 		count = SVC_I3C_MDATACTRL_RXCOUNT(mdatactrl);
-		readsl(master->regs + SVC_I3C_MRDATAB, buf, count);
+		readsb(master->regs + SVC_I3C_MRDATAB, buf, count);
 		slot->len += count;
 		buf += count;
 	}


