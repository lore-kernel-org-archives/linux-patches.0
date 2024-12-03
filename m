Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE9D1EF0AE;
	Tue,  3 Dec 2024 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239447; cv=none; b=tbpgYAzl0/rUouteutMvv0xqdp+52C8voF+AAveb5glXH/Cj+TAiFD4xLZGMWpcg8Vm9oocvI1tjcf74de5gvD+EZnGc6hbOzq5B7BP9T9BYrOBpOtbyNxtQFocKd3u/XhKNju20dZ6CxmKjj7j+w6vpvU+Sf0+7GQTYMXo1Dig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239447; c=relaxed/simple;
	bh=6No7yeTCh1M8kHTP8ND1PQPYn+ko0SkkCsoz3gP4ecM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThLcBt2CwRoXlqCBXCCXgxPHpct1Giyx93sDpbAfJwQisZJ2gyUsURnUpRDDjKtg/D0hhIQtjugrO9eM5YtJQ4bfsRiAARWPmquTBWwiIQuVAKD25gWw442i/3E+Hxco9XdnU5VwY0tyHON2mXAekJ39cZwYBEB+rGJE9U1m/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+wkNCGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+wkNCGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48192C4CECF;
	Tue,  3 Dec 2024 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239445;
	bh=6No7yeTCh1M8kHTP8ND1PQPYn+ko0SkkCsoz3gP4ecM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+wkNCGvY0QLBxzdgEY3YXPwoyri9rqBK1agf6n9W59c42DetNADRbXQLzF8XRnCE
	 iW787WsbhTFZHL17TIaHzz4rtAEEhdYizbhXdfO9cIXPfe6yNkimu6n84t6Pi/Kjoz
	 ENIqedU/iqvFwQ8yfvEo7TTYi8XBjkMR00+agtOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Panis <jpanis@baylibre.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 609/817] counter: ti-ecap-capture: Add check for clk_enable()
Date: Tue,  3 Dec 2024 15:43:01 +0100
Message-ID: <20241203144019.704313526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 1437d9f1c56fce9c24e566508bce1d218dd5497a ]

Add check for the return value of clk_enable() in order to catch the
potential exception.

Fixes: 4e2f42aa00b6 ("counter: ti-ecap-capture: capture driver support for ECAP")
Reviewed-by: Julien Panis <jpanis@baylibre.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241104194059.47924-1-jiashengjiangcool@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/ti-ecap-capture.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/counter/ti-ecap-capture.c b/drivers/counter/ti-ecap-capture.c
index 675447315cafb..b119aeede693e 100644
--- a/drivers/counter/ti-ecap-capture.c
+++ b/drivers/counter/ti-ecap-capture.c
@@ -574,8 +574,13 @@ static int ecap_cnt_resume(struct device *dev)
 {
 	struct counter_device *counter_dev = dev_get_drvdata(dev);
 	struct ecap_cnt_dev *ecap_dev = counter_priv(counter_dev);
+	int ret;
 
-	clk_enable(ecap_dev->clk);
+	ret = clk_enable(ecap_dev->clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable clock %d\n", ret);
+		return ret;
+	}
 
 	ecap_cnt_capture_set_evmode(counter_dev, ecap_dev->pm_ctx.ev_mode);
 
-- 
2.43.0



