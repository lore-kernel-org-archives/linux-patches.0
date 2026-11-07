Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062831;
	b=fVbHBiNMAj96uUE1hNV7lCbNkEoE/lij8e/rj0SOkE0O4wZa7rIJ0IfVr0fMceg8FMuk
	 ym+qj0ZugrsbUNcW+veTFu24WrDHo5kcHluCy6ug1DCTEfvnwBLxIpzODS2q8u72Jti0B
	 3V8koeGC8TwMYU343lUFDinSK9VzqwByLvKpXtUh/ioCF+49/NIDWsecAMIJ/c56TXh6W
	 3mU4mc0rse89btweUZEZW4s6HDuARi0qxHw5HXpcoxn27N/txp4k2njU4RMKovxhqAcQM
	 ReDCZrAprNA7/TRTgHdwr694h1r680mjU3VjaK6fBDfD62JBKHWPX5NiHZzvLI0UuAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EkXTb+79Lhp8S/+98MUtegQsRr7SkWYR8BUyryQYeYo=;
	b=bowEUay9oNcm76xkbpKAr27VQonCMbIo6FsfL+bJKDkQGYk1nGWd3F0v06muEH0IYenn
	 QaFyL/n9bWRN6U5HIdtd0z6QO8+2wkGFe5+gauWVqdnDh6BmZvLYNF8/tCEkoMOyHfygw
	 pAuKuP0ka/8rjC6LisvZQqyIxJvw4x/hmyV9va7HEZplUwhF7fX3E7g3T9djscN6jMRRx
	 zSVQTvPw4vDRm+p789H3FQN6edoakJsMMAa0etYfgAWaRuVbaDhyoCtBi3ZIt5u6udmAw
	 p7UpkSt9SiW+YhdDDnAZkotVOmSy47sdw8Tr6TmUn7WdOYqNmVWFDt1awq+rUUO/Xog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLPuMoXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01030606A334;
	Sat,  7 Nov 2026 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLPuMoXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F4B1F0089F;
	Sat,  7 Nov 2026 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062830;
	bh=EkXTb+79Lhp8S/+98MUtegQsRr7SkWYR8BUyryQYeYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLPuMoXCWlV1sLDRdKDLj4Hx9a1XXOZ1oZjDwXkRmOfasiNsz1uvZMuVlhLAxNn7e
	 mTF5JAux0EWRGldJWQJ3Ef4ahh1eppjQ94kow1hnseNiNuSAImr4UoLFQoABpent1h
	 wnWjX+EE9Np93qBPajeFwRTGRzieKVqxjgL7kGiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com,
	Piyush Patle <piyushpatle228@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/869] media: vidtv: fix frontend reference leak on unbind
Date: Sat,  7 Nov 2026 08:46:09 -0500
Message-ID: <20261107134855.686553972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piyush Patle <piyushpatle228@gmail.com>

[ Upstream commit 6f412f9fe6a1f3ce9694757f50353bbec221d832 ]

dvb_register_frontend() keeps two references to the frontend. One is
released by dvb_unregister_frontend(), and the other by
dvb_frontend_detach(). vidtv only called dvb_unregister_frontend(), so
the second reference was never released. As a result,
__dvb_frontend_free() was never called, leaking the frontend private
data and its struct dvb_device.

The detach call was removed by commit 63101b756893 ("media: vidtv: fix
driver unbind/remove") because it caused an OOPS. The demod .release
callback freed vidtv_demod_state, and the I2C remove callbacks then
accessed the freed state.

That commit also removed those accesses from the I2C remove callbacks.
Restore the detach call, but remove the demod .release callback.
vidtv_demod_state is owned by the I2C client and is already freed by
vidtv_demod_i2c_remove(), so the frontend detach path should not free
it.

Tested with kmemleak and KASAN over 10 bind/unbind cycles. The reported
frontend and dvb_device leaks were present before the fix and were gone
after it, with no KASAN reports.

Reported-by: syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=32f018fd65e799f79ae0
Fixes: 63101b756893 ("media: vidtv: fix driver unbind/remove")
Cc: stable@vger.kernel.org
Tested-by: syzbot+32f018fd65e799f79ae0@syzkaller.appspotmail.com
Signed-off-by: Piyush Patle <piyushpatle228@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c | 2 ++
 drivers/media/test-drivers/vidtv/vidtv_demod.c  | 9 ---------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index 8a8e097d2ac96..d6b90290bd4dd 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -474,6 +474,7 @@ static int vidtv_bridge_dvb_init(struct vidtv_dvb *dvb)
 fail_demod_probe:
 	for (i = i - 1; i >= 0; --i) {
 		dvb_unregister_frontend(dvb->fe[i]);
+		dvb_frontend_detach(dvb->fe[i]);
 fail_fe:
 		dvb_module_release(dvb->i2c_client_tuner[i]);
 fail_tuner_probe:
@@ -552,6 +553,7 @@ static void vidtv_bridge_remove(struct platform_device *pdev)
 
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
+		dvb_frontend_detach(dvb->fe[i]);
 		dvb_module_release(dvb->i2c_client_tuner[i]);
 		dvb_module_release(dvb->i2c_client_demod[i]);
 	}
diff --git a/drivers/media/test-drivers/vidtv/vidtv_demod.c b/drivers/media/test-drivers/vidtv/vidtv_demod.c
index 505f96fccbf30..36bfeb33476b2 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_demod.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_demod.c
@@ -343,13 +343,6 @@ static int vidtv_diseqc_send_burst(struct dvb_frontend *fe,
 	return 0;
 }
 
-static void vidtv_demod_release(struct dvb_frontend *fe)
-{
-	struct vidtv_demod_state *state = fe->demodulator_priv;
-
-	kfree(state);
-}
-
 static const struct dvb_frontend_ops vidtv_demod_ops = {
 	.delsys = {
 		SYS_DVBT,
@@ -390,8 +383,6 @@ static const struct dvb_frontend_ops vidtv_demod_ops = {
 			FE_CAN_HIERARCHY_AUTO,
 	},
 
-	.release = vidtv_demod_release,
-
 	.set_frontend = vidtv_demod_set_frontend,
 	.get_frontend = vidtv_demod_get_frontend,
 
-- 
2.53.0



