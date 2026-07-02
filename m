Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AEB347FC0;
	Thu,  2 Jul 2026 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009960; cv=none; b=Lm7lONEZh/4YJ9s3pQYrhKF3JMTDv29VpttnWksIwptcVhzIQv/3bgrCzv2p2+dGaWRFwhgQcKvl7yM18EBqFw5Hh4usRNe7tts8nn6rdJF5CCPLvNGb2rUG7jLuQTvIDq0fRQiy+H9Y92hZkti97w62GYvij4W7YbVD0bJwC4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009960; c=relaxed/simple;
	bh=IatmGBe8Uc8QN116SqDM7vkklgIpaxGVj6tcCe47HUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7br5PIgDqf7LsuvhMDT1bBY5uHV+tuqX7UtZ8SOlbTWMq6zrZtwBq8za5jNNQOaTfyaq3NFQd2MlYddqKivhFDm/sXtXW4qcewNysWSadrydmuSl13w9t+RLmH+xRZY6TplBLCxn3aF1suaAgf7PqwOxExBk4p0iA0Q5C51pKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1sPjll6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1sPjll6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AF01F000E9;
	Thu,  2 Jul 2026 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009959;
	bh=26uZkZ9kJ1JHq2vwKDcC5kAeeoXh9YzhphY+/GExzL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1sPjll6kZ31orqJYYZwhsZ/uNilhbS1BMQhNYTvIMPNgsLGd4BQRgNUhkGEUr069
	 m17vTHbf8W+Qv4rZ+jjnh599xvi8nZfgggs27zIPAR68lzL8knWfJnjklim9CTytoV
	 x1IG4QXzQcIg9J51uCjTS3trWmpHPer6qadCU2KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/129] batman-adv: tp_meter: fix fast recovery precondition
Date: Thu,  2 Jul 2026 18:19:34 +0200
Message-ID: <20260702155113.285941768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sven Eckelmann <sven@narfation.org>

commit 2b0d08f08ed3b2174f05c43089ec65f3543a025b upstream.

The fast recovery precondition checks if the recover (initialized to
BATADV_TP_FIRST_SEQ) is bigger than the received ack. But since recover is
only updated when this check is successful, it will never enter the fast
recovery mode.

According to RFC6582 Section 3.2 step 2, the check should actually be
different:

> When the third duplicate ACK is received, the TCP sender first
> checks the value of recover to see if the Cumulative
> Acknowledgment field covers more than recover

The precondition must therefore check if recover is smaller than the
received ack - basically swapping the operands of the current check.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 4ff80e4214ff0a..c79352cfddc4ae 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (recv_ack >= tp_vars->recover)
+		if (tp_vars->recover >= recv_ack)
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



