Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2351B174;
	Wed, 30 Sep 2026 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790839; cv=none; b=VKrFww+AtjvYuzi4LBBn74trkl+uYo+2037SM8U6ViouvpQUeINHyGVs0YDKzM1oVu0PoUxFp2DSK4xwp3x+6KALMw3QNN188VHBdXdh3L+qY8QwP8EmexcLv1syAfLWIsd1gI4DOT8ObdAn9jrmn5QD+NF1tlK4KeS+gey9XdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790839; c=relaxed/simple;
	bh=owN4vFb6hRXyPm7XdCEJT1qH0Yonhf/yIP0tNkcvUcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLs/66Y8yRc+XDUvtqi8zYxKItMn9oDyGv7KKh/vyYqztNovYIdG2bzpP+AA8s5BCcw46fIil/+PpTBKkHzbRBqoLo3hve8QWDq0tOgrVGqhXpzxI+uPt0myfGxkGDIAJawf0+VtcTdv3kbAxkLeUQSfXUaWlQ/ROVr8SDXTTVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM5HDKj2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM5HDKj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1093C1F000FF;
	Wed, 30 Sep 2026 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790838;
	bh=5QDkfQxZKt/7rriFuzCgKY4y9u285avUq0cS584b9CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LM5HDKj2MxT+iSMvcWSOM/6vU0eIgmojrkrT++HjpJb8wNdfBewj4zupj1uUP7pqW
	 uFBxJMi0pD8mmOzuxrqQqM73+mc26gmTbkAslw9zWL3PTooCQZxklSwO4lWxxBcvJn
	 3xtA8J4NXzXHZj7WKIlmpLdUQmLb6vbkIPzDuqP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/752] soundwire: only handle alert events when the peripheral is attached
Date: Wed, 30 Sep 2026 17:19:23 +0200
Message-ID: <20260930152400.180690584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 38cd651ebce7065a81c7e950d9e2ea1572304605 ]

It doesn't make sense to handle an alert event when the peripheral is
not attached. The slave->status could be SDW_SLAVE_ATTACHED or
SDW_SLAVE_ALERT when it is attached on the bus.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520025720.1999367-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 230a3250f3154..3317bc9221b48 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1798,6 +1798,10 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 			break;
 
 		case SDW_SLAVE_ALERT:
+			if (slave->status != SDW_SLAVE_ATTACHED &&
+			    slave->status != SDW_SLAVE_ALERT)
+				continue;
+
 			ret = sdw_handle_slave_alerts(slave);
 			if (ret < 0)
 				dev_err(&slave->dev,
-- 
2.53.0



