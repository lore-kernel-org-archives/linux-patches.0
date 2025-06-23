Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF317220686;
	Mon, 23 Jun 2025 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715118; cv=none; b=VM5XYlT6eR2/oYKqq8lnPyfdPnOWWo9KSV+xpWqy7MRcoj/vOsM3UvAhETHV9pKThwGDZIgfoQLAvVh9IMuRCKWZXV2BE7yJqjJpetc6ym9Em4Enr9NFgodvRQfi58zCILJs7awYCm5TdB5Lk2t8njKWuhZleyMweWtM1i2UfiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715118; c=relaxed/simple;
	bh=oyQS1KUg3zanR/YgOO37v0GTPcrNfzcL4hcisyvq9TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EmaWDf4Ta2azj/j/Rln1ElgDGYNnBADCAxBHTRMz7KOISWsi585UPj59A3ddZlnJhLkfbZ4CEqiffrukEAXJc9GICkmgQyNRcvF47l/JwD8QIr1sL0odSu+3KK2Cv7KgBSY/IMGbgkG3obosQ/tTZSZNEqMgaX4VMUbchX7sBC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uu55A3XJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uu55A3XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78025C4CEED;
	Mon, 23 Jun 2025 21:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715117;
	bh=oyQS1KUg3zanR/YgOO37v0GTPcrNfzcL4hcisyvq9TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uu55A3XJIy6eiKtkLe0+fGOpSCFCqC17j2W3B1Gtwl9jHVyt7XO/wu5YhReqUuVK8
	 clL3ceZ0w2SvbBwC5zXAm+zi8L9Z5QhKH0s0BkfeWHLMFDeL2bLwvPPghT8OiMWSKu
	 /hsRh4yJFgtAQhnsV731oSsMYgBxI9gyxcWFxQRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 438/592] platform/x86: dell_rbu: Fix list usage
Date: Mon, 23 Jun 2025 15:06:36 +0200
Message-ID: <20250623130710.853093568@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit 61ce04601e0d8265ec6d2ffa6df5a7e1bce64854 ]

Pass the correct list head to list_for_each_entry*() when looping through
the packet list.

Without this patch, reading the packet data via sysfs will show the data
incorrectly (because it starts at the wrong packet), and clearing the
packet list will result in a NULL pointer dereference.

Fixes: d19f359fbdc6 ("platform/x86: dell_rbu: don't open code list_for_each_entry*()")
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Link: https://lore.kernel.org/r/20250609184659.7210-3-stuart.w.hayes@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell_rbu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index e30ca325938cb..e2afe51b66ee8 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -292,7 +292,7 @@ static int packet_read_list(char *data, size_t * pread_length)
 	remaining_bytes = *pread_length;
 	bytes_read = rbu_data.packet_read_count;
 
-	list_for_each_entry(newpacket, (&packet_data_head.list)->next, list) {
+	list_for_each_entry(newpacket, &packet_data_head.list, list) {
 		bytes_copied = do_packet_read(pdest, newpacket,
 			remaining_bytes, bytes_read, &temp_count);
 		remaining_bytes -= bytes_copied;
@@ -315,7 +315,7 @@ static void packet_empty_list(void)
 {
 	struct packet_data *newpacket, *tmp;
 
-	list_for_each_entry_safe(newpacket, tmp, (&packet_data_head.list)->next, list) {
+	list_for_each_entry_safe(newpacket, tmp, &packet_data_head.list, list) {
 		list_del(&newpacket->list);
 
 		/*
-- 
2.39.5



