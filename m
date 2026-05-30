Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3DE282F23;
	Sat, 30 May 2026 18:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165638; cv=none; b=Zan91wXYJJ2itfUgx3odApKwDJsItPvCwAi5GsFCt+Rf4cD0amTUCrMOvDz7SAcnSwOWaeYLLcEq4VZmevX5f35a36uAJLVYDJjm606kHPa6NJwP4T/DsTNALKJMVfsg1cr0PByeW91rZq/mJQxrshVm5nyAvgorvvmxn1ypDyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165638; c=relaxed/simple;
	bh=aBH5JDdI5CQaupu0iKMXvrpWjliK132xVdO/ea6G++g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SndMaKkXVYjTK851DcQw5sX8zu8i3xTVvjaHhIt1g+X++gwzTusXIyE3TA8pfD2nPeIhKqfNRM2esxfLza8fpjjDQP+0NAJofCyou/cbf9dnh3Hix92wHcOmbOL6u22+1nF6YesizDzK2PSVrHl2GehwmqbPwOxMymsOjJXFfWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+XPZFo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+XPZFo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE111F00893;
	Sat, 30 May 2026 18:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165637;
	bh=IVRGKGuwVb7nJfPd6QSTPjnXWF1Ii5TPZJQS85k3PW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+XPZFo4dcAufT9ev0ry+/vY+Tzeus2i7mpU3c4bpdiUEZU8wy1pCTAcAeX6Gs+1U
	 xggOEtu7rAIgZ2EQz7qspsfKY2XFFULwgFDJQyUnKhi08Pbxl8lSDZLaIF0J/Q2MeX
	 gwrRieBApv83P3AboOZ9obyRTtUKioDZIozKZIz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-kernel@vger.kernel.org, sashal@kernel.org,  Joonwon Kang" <joonwonkang@google.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Joonwon Kang <joonwonkang@google.com>
Subject: [PATCH 5.10 099/589] mailbox: Prevent out-of-bounds access in of_mbox_index_xlate()
Date: Sat, 30 May 2026 17:59:40 +0200
Message-ID: <20260530160227.297377817@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit fcd7f96c783626c07ee3ed75fa3739a8a2052310 ]

Although it is guided that `#mbox-cells` must be at least 1, there are
many instances of `#mbox-cells = <0>;` in the device tree. If that is
the case and the corresponding mailbox controller does not provide
`fw_xlate` and of_xlate` function pointers, `of_mbox_index_xlate()` will
be used by default and out-of-bounds accesses could occur due to lack of
bounds check in that function.

Cc: stable@vger.kernel.org
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ changed sp->nargs to sp->args_count in the code and
fw_mbox_index_xlate() to of_mbox_index_xlate() in the commit message. ]
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/mailbox.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -468,12 +468,10 @@ static struct mbox_chan *
 of_mbox_index_xlate(struct mbox_controller *mbox,
 		    const struct of_phandle_args *sp)
 {
-	int ind = sp->args[0];
-
-	if (ind >= mbox->num_chans)
+	if (sp->args_count < 1 || sp->args[0] >= mbox->num_chans)
 		return ERR_PTR(-EINVAL);
 
-	return &mbox->chans[ind];
+	return &mbox->chans[sp->args[0]];
 }
 
 /**


