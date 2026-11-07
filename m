Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062277;
	b=FEUMiGkSFlGEoZt6wgCU0YrVhCBwflGiz8F1Ko7Y28YcVEcSKA/v+tAcWdEeXV+jmaIh
	 ESYcrTeZ5i6VVi1J1cDjxC0+kE8aPlQteF80ywcHlAVgPoqiZ1OaeCPL0O4JD8zuFLYgB
	 vB3zi5RkJFnmgXigvdUb0YwUH7iJeP78N7k0W0rTNqUgSSSkC1vyqx47PthjEvDRurFqF
	 p0TYPsWIbMlW9xeGb7sPW3+YuKX1N2mO7FGH3CWq2Q+L9P2Q0ZUTbEcyxXU6V1hCNWQ1+
	 wEqjTZvR5fJZ98qQQIoW7tTRBqxVXRT3y5GT64l5JZXtpaEiPfoqsFaIe6ukELsq5rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fiOW41PWrSu+AJq9NIxi6tOnGo5Qq+dvxsZ6l4rfs4I=;
	b=pqLfT59htq1AzVgp42ymsWDyiL8C+rBlOgdOtFPaRaSfh1barWFQKG6M+lg4OsIJwpuT
	 DzP4TJFrnzlJx0Wq4dNsZ1PkmTQW9c5+jUmeY524xYklw8v4x2X6jsA5CzaA4YLqmHbFw
	 ZR7WeIgLVXu2BORrMrQpLQ4+7BDCBzjQvvg3fz7wnxJwFHPxZVOcfv8GvFj+kWEskCXB6
	 gHEAD529aIVGvBgCjgtWtYqsb+OcxOXpI+2lq7z+5cHQIT1p21OIMdDhbJEUVp+gSBQvk
	 ao2Y99BBhs/PdUp2I//VHC/TBHaXTXVnaXx2AnDkLsmFOWjlVeF4bA0JhvJYP7QhPEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYnNY3Ka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367D2606D804;
	Sat,  7 Nov 2026 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYnNY3Ka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79B41F0089F;
	Sat,  7 Nov 2026 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062277;
	bh=fiOW41PWrSu+AJq9NIxi6tOnGo5Qq+dvxsZ6l4rfs4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYnNY3KabxSbXJEd4C7WagOIJnCA8GMydWUxSwzokHmR7f3WLMF7M9e6xcLC3O6lL
	 Jsw3mxqzQ9D8FM3neSlg+xIRHTMLDOi/F9A9HDyCrOBMqHEmeNdp1tDZcG74+oHfVr
	 lCX4eoZa/TYG36oFKcOWyakCfzr4fdeFrFpuBNr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1217/1536] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Sat,  7 Nov 2026 08:53:53 -0500
Message-ID: <20261107135031.939393759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit c26cc979e28f5193310e4379e14aa6417375c565 ]

In slim_do_transfer(), when a transaction needs a tid and
slim_alloc_txn_tid() fails, the function returns directly instead of
jumping to slim_xfer_err. The runtime PM vote taken earlier with
pm_runtime_get_sync() is then never released, leaving the controller
permanently powered up.

As txn->tid is still 0 at that point, jumping to slim_xfer_err drops
the vote exactly like it is done for other failed transactions.

Fixes: d3062a2109309 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101448.1084691-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index 455c1fd1490fd..f06c42f4a96b2 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -139,7 +139,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	if (need_tid) {
 		ret = slim_alloc_txn_tid(ctrl, txn);
 		if (ret)
-			return ret;
+			goto slim_xfer_err;
 
 		if (!txn->msg->comp)
 			txn->comp = &done;
-- 
2.53.0



