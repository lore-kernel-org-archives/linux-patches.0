Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C07A18E778;
	Tue, 10 Sep 2024 09:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961588; cv=none; b=T6djL0A8IDMGAXUTsxeE1jE7Id5d7MM7EfCJLF8lUg8Lv4KD5ibm8UGO+YIWIabE0FvvzgxFso85z4bVTtsOcdsO9Sfs+jOjSRab2wVSyhlsG+rJOfczpIiLj2vBZsBmDG4H706PZIUdugFRSv52TsxJF8B5ShnpMQXatdvxCZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961588; c=relaxed/simple;
	bh=ioc2HpjzaxfoF/gn5OD5zjLMpDJ6WFyileA3HqfFIRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1Plwegwr2b4WnvB20wGwxYJhoK2/2tfZY5temDd1C7laMClCC7MfQvAT8KOXHVpzQpOJhw9md794LsM6UljJVRx+OtZplF4Z1P9/CmOhdBn2psEhXWmqPXb1APPNUecf3GeujqC779hE0RiEgl/WzFV9SggdQuKKZGzZ7O+Eik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDzb4PD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDzb4PD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4AFC4CEC3;
	Tue, 10 Sep 2024 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961588;
	bh=ioc2HpjzaxfoF/gn5OD5zjLMpDJ6WFyileA3HqfFIRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDzb4PD51uvYNcTjsOf2d9//6PM6cKJaCBMj8acKqDfO2PQBnRc7YXadlxJsQGTnK
	 vaiJh5iX87L/53Rsv1Px4Zs0Hj7/ohIhdXPT5W60Y+nyzNvWti1LClWzwoE3g/xtBQ
	 bmV2urY7iekaJsP5lcgF9mKtUPP6kSDVFFiWRqLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 121/375] usb: gadget: aspeed_udc: validate endpoint index for ast udc
Date: Tue, 10 Sep 2024 11:28:38 +0200
Message-ID: <20240910092626.501728101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit ee0d382feb44ec0f445e2ad63786cd7f3f6a8199 ]

We should verify the bound of the array to assure that host
may not manipulate the index to point past endpoint array.

Found by static analysis.

Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20240625022306.2568122-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index 821a6ab5da56..f4781e611aaa 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -1009,6 +1009,8 @@ static void ast_udc_getstatus(struct ast_udc_dev *udc)
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = crq.wIndex & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum >= AST_UDC_NUM_ENDPOINTS)
+			goto stall;
 		status = udc->ep[epnum].stopped;
 		break;
 	default:
-- 
2.43.0



