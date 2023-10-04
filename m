Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADACC1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+nIzeF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD5EC433CA;
	Wed,  4 Oct 2023 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443820;
	bh=M5k51TsGe5OcyO3CZ8ssH+vwVxFKVhGsgSznGlIdQlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+nIzeF0cRVl1vhNwyTmAHoyAgjTlxnVQhCoRqxKVi8DeifepD/qiEaAD/N/DVcZp
	 ayisBrxpJvLnE5PlsFytsEETJv+AXj2sKYANcUyYLRnsa6+j4T7rQlc/7J0FcY2uLe
	 8e3p6UWCk5PLJX98fUKU8i1v6lvH14ZsQRR73CeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sameer Pujar <spujar@nvidia.com>,
	Oder Chiou <oder_chiou@realtek.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 032/321] ASoC: rt5640: Fix sleep in atomic context
Date: Wed,  4 Oct 2023 19:52:57 +0200
Message-ID: <20231004175230.650636363@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit df7d595f6bd9dc96cc275cc4b0f313fcfa423c58 ]

Following prints are observed while testing audio on Jetson AGX Orin which
has onboard RT5640 audio codec:

  BUG: sleeping function called from invalid context at kernel/workqueue.c:3027
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/0
  preempt_count: 10001, expected: 0
  RCU nest depth: 0, expected: 0
  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:159 __handle_irq_event_percpu+0x1e0/0x270
  ---[ end trace ad1c64905aac14a6 ]-

The IRQ handler rt5640_irq() runs in interrupt context and can sleep
during cancel_delayed_work_sync().

The only thing which rt5640_irq() does is cancel + (re-)queue
the jack_work delayed_work. This can be done in a single non sleeping
call by replacing queue_delayed_work() with mod_delayed_work(),
avoiding the sleep in atomic context.

Fixes: 051dade34695 ("ASoC: rt5640: Fix the wrong state of JD1 and JD2")
Reported-by: Sameer Pujar <spujar@nvidia.com>
Closes: https://lore.kernel.org/r/1688015537-31682-4-git-send-email-spujar@nvidia.com
Cc: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230912113245.320159-3-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 7ec930fb9aab5..24c1ed1c40589 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2404,13 +2404,11 @@ static irqreturn_t rt5640_irq(int irq, void *data)
 	struct rt5640_priv *rt5640 = data;
 	int delay = 0;
 
-	if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER) {
-		cancel_delayed_work_sync(&rt5640->jack_work);
+	if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER)
 		delay = 100;
-	}
 
 	if (rt5640->jack)
-		queue_delayed_work(system_long_wq, &rt5640->jack_work, delay);
+		mod_delayed_work(system_long_wq, &rt5640->jack_work, delay);
 
 	return IRQ_HANDLED;
 }
-- 
2.40.1



