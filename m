Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AA426B082;
	Thu, 13 Feb 2025 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459324; cv=none; b=a4hGuE/+4DTn95/JCVuf8q+7CQmq9tr4a0b8s1M9YoZDJJAgZYFdVCREiSZkh7Laj2ENLqyv3Bo4KdXp63bqWRjkq58emFdNSZdcUAEwvBhWnoH9beqHlkIOUIiUlabumftdeGSrZJnR/XgupPgxSzund/7pkSUx61L17eNw7fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459324; c=relaxed/simple;
	bh=aCKPpj9HPzYOUMC+9t7qfd0eJaf06PdVcmqcBZm3j0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3kehaGyMf6PdMjDX1vzCzraucgionKMWvyUIwwOTSKANxRsVjh72oVnZBx1swtJ6Gi5OqbDfyTtpNb2ewztJQSXJQ2QmjbhWP1SK5cfz2f0GEp+/nsegWTN9ZsVdwPYxCqGJHHeMzW04tKEEAN4FePpDbVGGDN+iTEJVp9kaNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifztfq+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifztfq+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65E2C4CEE4;
	Thu, 13 Feb 2025 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459324;
	bh=aCKPpj9HPzYOUMC+9t7qfd0eJaf06PdVcmqcBZm3j0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifztfq+DW9TkirfnIRprwC4rVcjn6nMp4SpNcCy3vToDJ2IMgLy3TNOgLpDiWf+18
	 BoiLXMUjnc3nE0afAytRnZeo7VFWryvntKWspNO8RVOUFQTmUEd7PvMWjMGYX/OZVN
	 H+RRNEL6UO3Zc66QEuWo0eOyy2pyixaRoP0JTvak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 231/443] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Thu, 13 Feb 2025 15:26:36 +0100
Message-ID: <20250213142449.528657301@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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
 


