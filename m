Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD707474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C41C433F1;
	Tue, 10 Jan 2023 18:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374880;
	bh=wGyhgb7U9PY0ekhVRi71tmHvknvpHKkja434Vir8Xro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wr9uk+DeEg3uxZ7J/87b7Wtg5c4bP6vc6BGHcId5DxOsAb4v3DP3flS9KQ/SrXWXM
	 L3r9wxXjGFX2CGdKYSEA/54Jsozeqx152uKq67Oh0HCqrs+4ejBLO7VKNBRhj6lEa4
	 uSMwuSEXHPhBKIGRIIOxTbQkWDnBKD/kc3+/zvDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Luigi Semenzato <semenzato@chromium.org>,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Johannes Altmanninger <aclopte@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.1 138/159] tpm: Allow system suspend to continue when TPM suspend fails
Date: Tue, 10 Jan 2023 19:04:46 +0100
Message-Id: <20230110180022.808719530@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 1382999aa0548a171a272ca817f6c38e797c458c upstream.

TPM 1 is sometimes broken across system suspends, due to races or
locking issues or something else that haven't been diagnosed or fixed
yet, most likely having to do with concurrent reads from the TPM's
hardware random number generator driver. These issues prevent the system
from actually suspending, with errors like:

  tpm tpm0: A TPM error (28) occurred continue selftest
  ...
  tpm tpm0: A TPM error (28) occurred attempting get random
  ...
  tpm tpm0: Error (28) sending savestate before suspend
  tpm_tis 00:08: PM: __pnp_bus_suspend(): tpm_pm_suspend+0x0/0x80 returns 28
  tpm_tis 00:08: PM: dpm_run_callback(): pnp_bus_suspend+0x0/0x10 returns 28
  tpm_tis 00:08: PM: failed to suspend: error 28
  PM: Some devices failed to suspend, or early wake event detected

This issue was partially fixed by 23393c646142 ("char: tpm: Protect
tpm_pm_suspend with locks"), in a last minute 6.1 commit that Linus took
directly because the TPM maintainers weren't available. However, it
seems like this just addresses the most common cases of the bug, rather
than addressing it entirely. So there are more things to fix still,
apparently.

In lieu of actually fixing the underlying bug, just allow system suspend
to continue, so that laptops still go to sleep fine. Later, this can be
reverted when the real bug is fixed.

Link: https://lore.kernel.org/lkml/7cbe96cf-e0b5-ba63-d1b4-f63d2e826efa@suse.cz/
Cc: stable@vger.kernel.org # 6.1+
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Luigi Semenzato <semenzato@chromium.org>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Johannes Altmanninger <aclopte@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-interface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d69905233aff..7e513b771832 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -412,7 +412,9 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 suspended:
-	return rc;
+	if (rc)
+		dev_err(dev, "Ignoring error %d while suspending\n", rc);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 
-- 
2.39.0



