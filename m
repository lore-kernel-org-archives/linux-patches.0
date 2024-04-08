Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39276214E;
	Mon,  8 Apr 2024 13:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581279; cv=none; b=tEbvQWUjJxn7kSlj+OCl2kE0AubKirxPjGV215e4SjLGit/u/CIuIgZhFnh64eNbPK4DvCIdlww5UokVIoUVTRpV7RYFDGioUiHJ59n/Zs82bcCWcxgJSb6IyXipNuVfg833F8Y33l9YZRvmxxzjX8rLqWIdHd0FCsf0t+9QF8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581279; c=relaxed/simple;
	bh=Aghz3UPNlTLfE+C3snHByYZzkYjUmORmmC9QFmg3Fos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1osXFk1eXWk8PplafEWvmP3JdijaGf6yCtT5ohbMn59OdMT7CuZNHfMHMrtV8i+UoMGjan8SdwuINcLo7C9i30ISaPkN/YhB1GxDZ8Mcpq6SwdGuyYkBQPW4ZIDAgLJ1r9QtgrmrUZOXdxgGCkmMAvF/B1tfwUfitlwMbscpmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufceY66a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufceY66a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFDFC433F1;
	Mon,  8 Apr 2024 13:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581279;
	bh=Aghz3UPNlTLfE+C3snHByYZzkYjUmORmmC9QFmg3Fos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufceY66atORK7Berdk9vqQ6awf53bVOW4jd2XWNEqSgrTcRGn6ekTdomnc0d85Bfd
	 BxklwrBRIIrEuP3McNvkqhgJ+vWJkOBBrKWbNgOAWzRm0wm7Qw9INjKG5TE+4LUoVk
	 DHGjnD5JSH5Ivc9BAmu8eA1MBSytK9NKjXcm0TGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Gui-Dong Han <2045gemini@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/690] media: xc4000: Fix atomicity violation in xc4000_get_frequency
Date: Mon,  8 Apr 2024 14:48:04 +0200
Message-ID: <20240408125400.223420505@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <2045gemini@gmail.com>

[ Upstream commit 36d503ad547d1c75758a6fcdbec2806f1b6aeb41 ]

In xc4000_get_frequency():
	*freq = priv->freq_hz + priv->freq_offset;
The code accesses priv->freq_hz and priv->freq_offset without holding any
lock.

In xc4000_set_params():
	// Code that updates priv->freq_hz and priv->freq_offset
	...

xc4000_get_frequency() and xc4000_set_params() may execute concurrently,
risking inconsistent reads of priv->freq_hz and priv->freq_offset. Since
these related data may update during reading, it can result in incorrect
frequency calculation, leading to atomicity violations.

This possible bug is found by an experimental static analysis tool
developed by our team, BassCheck[1]. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations. The above
possible bug is reported when our tool analyzes the source code of
Linux 6.2.

To address this issue, it is proposed to add a mutex lock pair in
xc4000_get_frequency() to ensure atomicity. With this patch applied, our
tool no longer reports the possible bug, with the kernel configuration
allyesconfig for x86_64. Due to the lack of associated hardware, we cannot
test the patch in runtime testing, and just verify it according to the
code logic.

[1] https://sites.google.com/view/basscheck/

Fixes: 4c07e32884ab ("[media] xc4000: Fix get_frequency()")
Cc: stable@vger.kernel.org
Reported-by: BassCheck <bass@buaa.edu.cn>
Signed-off-by: Gui-Dong Han <2045gemini@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/xc4000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index ef9af052007cb..849df4d1c573c 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1517,10 +1517,10 @@ static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 
+	mutex_lock(&priv->lock);
 	*freq = priv->freq_hz + priv->freq_offset;
 
 	if (debug) {
-		mutex_lock(&priv->lock);
 		if ((priv->cur_fw.type
 		     & (BASE | FM | DTV6 | DTV7 | DTV78 | DTV8)) == BASE) {
 			u16	snr = 0;
@@ -1531,8 +1531,8 @@ static int xc4000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 				return 0;
 			}
 		}
-		mutex_unlock(&priv->lock);
 	}
+	mutex_unlock(&priv->lock);
 
 	dprintk(1, "%s()\n", __func__);
 
-- 
2.43.0



