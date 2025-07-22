Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C592877FA;
	Tue, 22 Jul 2025 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192708; cv=none; b=QFA9bMEEZhP/NWyxCOCPG+4WFTDvQBbC5pkQa0CRoKSpmLIGnpCaG2SOO4+HZjC/60eDNvnzaI5p4afZivXfe4tUlFc2EOeSG+CFo0tU5kt08rLRIA/22pqbKYBAYuXi4b+3pgkBjKANquktb3lOt7G/RhbkPjaw6xoupGMvHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192708; c=relaxed/simple;
	bh=4GTZ2CgN87VSrcYJ/m86Z59n8PIpwciKqpR6SweuKz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB2HCpIaevEnan5zN0TnoWXkILmP+EXE7hCydW+IdvDBJ7hc81x19Cv6BuEeWfYwRBqUOa1nO5zmW2poI+UtTKpVSRAxY0HlEnbMyGGMEnPBflcT1f/KntBo8RU9ZSJ/5gZpyBpRkn/cLMEewLwQmI6oL07lQ4sO6tWyeYYy/o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3Q4z4X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3Q4z4X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6651EC4CEEB;
	Tue, 22 Jul 2025 13:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192707;
	bh=4GTZ2CgN87VSrcYJ/m86Z59n8PIpwciKqpR6SweuKz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3Q4z4X38swWC+JlRDmWT5/69MGvjyyu/HiM4o6gxIxhDwzuXIOH0E1jQ7vA6YEK4
	 i1xmwFMTmDsyQpRTRBvZQH/KY5Eot7zYxExKzuj+HlEHiwrq1+DcfBSlkKsySpia7s
	 AliYNjuZat9IW7T/ceNdkkqxm1QencpqlzV/vj48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 009/158] usb: gadget: configfs: Fix OOB read on empty string write
Date: Tue, 22 Jul 2025 15:43:13 +0200
Message-ID: <20250722134341.081624071@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinyu Liu <1171169449@qq.com>

commit 3014168731b7930300aab656085af784edc861f6 upstream.

When writing an empty string to either 'qw_sign' or 'landingPage'
sysfs attributes, the store functions attempt to access page[l - 1]
before validating that the length 'l' is greater than zero.

This patch fixes the vulnerability by adding a check at the beginning
of os_desc_qw_sign_store() and webusb_landingPage_store() to handle
the zero-length input case gracefully by returning immediately.

Signed-off-by: Xinyu Liu <katieeliu@tencent.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/tencent_B1C9481688D0E95E7362AB2E999DE8048207@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1065,6 +1065,8 @@ static ssize_t webusb_landingPage_store(
 	unsigned int bytes_to_strip = 0;
 	int l = len;
 
+	if (!len)
+		return len;
 	if (page[l - 1] == '\n') {
 		--l;
 		++bytes_to_strip;
@@ -1188,6 +1190,8 @@ static ssize_t os_desc_qw_sign_store(str
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res, l;
 
+	if (!len)
+		return len;
 	l = min((int)len, OS_STRING_QW_SIGN_LEN >> 1);
 	if (page[l - 1] == '\n')
 		--l;


