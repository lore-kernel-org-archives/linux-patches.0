Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CC419E975;
	Thu, 13 Feb 2025 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460656; cv=none; b=AYkHo7ZOm1zBp4Hp12xVBql33WoPwAWxZrBTuEA8CyRzu+x/92eJQYgMLHmf+xUNgkHZpXeXyhxQUmHWW3HBjacrqERbl5jUhcLVhMGrkk/Lftl9eUWWK02fwe+WCh9PNbLoR7nur3NVh0R+15cxDioxyQJnLo5wbvm4pTC5Ot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460656; c=relaxed/simple;
	bh=XvuTOaWTYzcdGA0/7g9SxwkIxEuYkzr57kyL1SdZpS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB444K+SvT1gNJvVGOUC33Eg3N68cxubwMNh2CtLQ3r2w/Ewz/ZKPNqUnqKleYfnLC6QgaPj1SXysxk3+uWGRLVRcjxoJeyAXPEqrnZKhjikKbN6u1BcrI37LGuD6tcsUH0sJbna35WJQhF8AZSCso7wugWu9DuJnrZP0CnePt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUqK2QFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUqK2QFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056DEC4AF0B;
	Thu, 13 Feb 2025 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460655;
	bh=XvuTOaWTYzcdGA0/7g9SxwkIxEuYkzr57kyL1SdZpS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUqK2QFNA+WX5VIPfpRMJUzsgffe10jITQuxsCKCK84ifQPnFNCS4jp6AYQ2GTsja
	 Jc29cb3UmiBBxOY0HsCZp0V0iO/+iZEnyYOYFriD9SG15A+wt6afEO72yoFzgMHe1L
	 rvQiDgV9NFOsWPI325cqqce3Vi6MJl6uc/nvWnBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 133/273] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Thu, 13 Feb 2025 15:28:25 +0100
Message-ID: <20250213142412.593114345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b2a52e88ab0c9469eaadd4d4c8f57d072477820 upstream.

We submitted the command with TARGET_SCF_ACK_KREF, which requires
acknowledgment of command completion. If the command fails, make sure to
decrement the ref count.

Fixes: cff834c16d23 ("usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c667b4d9c8b0b580346a69ff53616b6a74cfea2.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -973,6 +973,7 @@ static void usbg_data_write_cmpl(struct
 	return;
 
 cleanup:
+	target_put_sess_cmd(se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 


