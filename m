Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209486;
	b=1FKwGbkHIO/HweOXMjWyrctT3WZA75y6VZUru37Ja9BsrNhIYnVsLLGnxaX/hNBucsgm
	 l+qGS4tkBAhFPE4VJ2niWLrdRL6Nl20ahp/qpwDmtaOEjmkijBaGsz149lEp5BZZjy/6M
	 5q3HEkgXi8dh5MMrAYZu2xIdN65c0cnc91B9RqaUUrRp3Buixq71FT9GqlXQ0AEg+o4M4
	 gV+TopVAlzkquSSpyajnlN5H7FS/v73uyXlpRH7wFIHvdVRfL7LMEi8qvspUa/pSOQv1N
	 haKFDL+rESd7jxJxftciYTwzWoDCPJa1xd3SZojqhgScWbULq1lGcw6TPl2p9qjRC8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOnUkKtibxl541VdVuM8ULp46CqxI+xwd+Op0LzEqBs=;
	b=NLDV47G+oVYE83BpjHZoK9PMYToSwdNouyeEkzo7GO1M99oktRgLMb8jsp10j8sQUdpX
	 nAH523v8JYtdKXU1ELNW64uK3fLmblMaXXjKTTa39EryBAMzKVqExvb+69uLDdkM9l+8a
	 ulULgBstC66EMTPKOEtJiL+wPKWC9cbwrzFveBtq+88DAh/wH31dI+8sA8Tv6xTqi8Ttm
	 OWWBgrhXoX5kZNWrDtCFCs4E4W8z14JVZkWhjRH7Lbe39k1+RyJdUisC+VpAo5ipZ11CT
	 PMKqX2bSzM4q8MQeMRXfJtzzRVqEEPSCuuf0yk0Pr7Fl4DB5T2+3AvQAw8uOpyQ3YuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kt+Ensn+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FD1606A32D;
	Wed, 28 Oct 2026 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kt+Ensn+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EE11F01829;
	Wed, 28 Oct 2026 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209486;
	bh=WOnUkKtibxl541VdVuM8ULp46CqxI+xwd+Op0LzEqBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt+Ensn+k4f5a8V7hQn2LEr12kmd5p6QIzlbN4y+rKyooAZzmlMgYUdie+TM3ktyV
	 PgElerRiBNpFfqI5ZU5odW2001b6qJi4S6kz0X0eKgwC2CJXgZR88cSatMhQvd6b5b
	 PeadYvj8K59xzgzK5IBbVluKtZJaxVlwfPZz0OYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/516] Input: byd - synchronize timer deletion before freeing private data
Date: Wed, 28 Oct 2026 18:00:40 +0100
Message-ID: <20261028170015.038066033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit c83e79c0842ed29860648bcce5022ef0ba5001c6 ]

byd_disconnect() uses timer_delete() before freeing the driver's private
data.  This does not wait for a running byd_clear_touch() callback, which
dereferences the private data and its psmouse pointer.  A callback racing
with disconnect can therefore access the private data after it has been
freed.  The timer can also still be re-armed by byd_process_byte() while
the disconnect is in progress.

Use timer_shutdown_sync() before freeing the private data: it waits for
a running callback and turns any later re-arm attempt into a no-op.

Fixes: 2d5f5611dd0d ("Input: byd - enable absolute mode")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720061259.1601281-1-lilinmao@kylinos.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/byd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/byd.c b/drivers/input/mouse/byd.c
index 6e0c5f5a2713d..1a0956520dcbe 100644
--- a/drivers/input/mouse/byd.c
+++ b/drivers/input/mouse/byd.c
@@ -426,7 +426,7 @@ static void byd_disconnect(struct psmouse *psmouse)
 	struct byd_data *priv = psmouse->private;
 
 	if (priv) {
-		del_timer(&priv->timer);
+		timer_delete_sync(&priv->timer);
 		kfree(psmouse->private);
 		psmouse->private = NULL;
 	}
-- 
2.53.0



