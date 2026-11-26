Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704357;
	b=cJ+Htncx9OnVtgA7qT9ohzHzqDl5u9Kj0lSG7rr1drg61bUWEAYfaHtLvwJfxV4tBp1j
	 OKYDFAfWK8i970JE7AW3S9XlVF42xCFRDdLDQZCnBLdiSxcmUK7SOIt78bj6f615h2ejc
	 75OOLlKhEqQp+q+ZJMLvBPzYgyON3HPoRiwy/0xXBHROJwt7WSmcUjittJK0RvIyL1cYV
	 0d+FNA2hr0GZ4hh1tZZq519vwT8Ur781N7lQvcC0AzcRqcYTXYA/QYC8SWUzAbHpDqe7h
	 EY8Lzdb3t5ApJn7FigJ0mD03f2qkLkdvTO2u/5sYji0Z/MOz89nkRU7Ox25zjC1HgGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OTfHta3BZZa8uWSbksq2+Dmn3rGb49p8vJuTtlKK8Hk=;
	b=pO6YLmIcSNKwLaDfNmlpaEZlxVnrpLLaPaUWzgRS8vQ0z493jUNlRqUvZWzH8clobYnU
	 VaIgduK1SKeC8FTQXLYnEtfWRVNihkTag2fTNOCRB0pBmHYTyjAsBO+9/9iyydwzXvFbQ
	 /Tl6lYts8UD8ngw3WQchvqK3aEDeusEotnxUK+QQtj9AxVBe64oPGuozYU99061uGZYrZ
	 V2UR6HsxN0CNXIPAgexRizLF66oTX3Et3TRN4MyB0gAbkKbrKpzvM2WWdX4JiYsj44gik
	 /DY/C50QKrOFuO75MCVpyvjp8nWrjBQpGIRAk8Iso+SpRfQjw+VJ+khe7kjMzCSmOGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7E9eT03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D253606A31E;
	Thu, 26 Nov 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7E9eT03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579971F000C4;
	Thu, 26 Nov 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704356;
	bh=OTfHta3BZZa8uWSbksq2+Dmn3rGb49p8vJuTtlKK8Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7E9eT03+rZHQb07JXFNE00BsTUXzCNk7bqAmX52aH5jDiEwhHb7NoV+pj4ytDjIC
	 k+hL79nux6rBfaH6e4fWAxS5ayjUBoWX2sGV5kiVmuqqKUwMV4Qf7AXZD8yU4CpYAE
	 aFJ2PgtFW30fIm/iPT9KU6tq3Md61z2NoQ8xwWMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/265] regmap: teach regmap to use raw spinlocks if requested in the config
Date: Thu, 26 Nov 2026 15:36:21 +0100
Message-ID: <20261126143608.681046913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 67021f25d95292d285dd213c58401642b98eaf24 ]

Some drivers might access regmap in a context where a raw spinlock is
held. An example is drivers/irqchip/irq-ls-extirq.c, which calls
regmap_update_bits() from struct irq_chip :: irq_set_type, which is a
method called by __irq_set_trigger() under the desc->lock raw spin lock.

Since desc->lock is a raw spin lock and the regmap internal lock for
mmio is a plain spinlock (which can become sleepable on RT), this is an
invalid locking scheme and we get a splat stating that this is a
"[ BUG: Invalid wait context ]".

It seems reasonable for regmap to have an option use a raw spinlock too,
so add that in the config such that drivers can request it.

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20210825205041.927788-2-vladimir.oltean@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 053c50a70525 ("regulator: qcom_spmi: don't take a sleeping lock in the SAW IPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/internal.h |  4 ++++
 drivers/base/regmap/regmap.c   | 35 +++++++++++++++++++++++++++++-----
 include/linux/regmap.h         |  2 ++
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 2720d8d7bbfc9..93e028445dade 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -53,6 +53,10 @@ struct regmap {
 			spinlock_t spinlock;
 			unsigned long spinlock_flags;
 		};
+		struct {
+			raw_spinlock_t raw_spinlock;
+			unsigned long raw_spinlock_flags;
+		};
 	};
 	regmap_lock lock;
 	regmap_unlock unlock;
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3ad37e5615ea4..6945bcf72ee1a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -525,6 +525,23 @@ __releases(&map->spinlock)
 	spin_unlock_irqrestore(&map->spinlock, map->spinlock_flags);
 }
 
+static void regmap_lock_raw_spinlock(void *__map)
+__acquires(&map->raw_spinlock)
+{
+	struct regmap *map = __map;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&map->raw_spinlock, flags);
+	map->raw_spinlock_flags = flags;
+}
+
+static void regmap_unlock_raw_spinlock(void *__map)
+__releases(&map->raw_spinlock)
+{
+	struct regmap *map = __map;
+	raw_spin_unlock_irqrestore(&map->raw_spinlock, map->raw_spinlock_flags);
+}
+
 static void dev_get_regmap_release(struct device *dev, void *res)
 {
 	/*
@@ -774,11 +791,19 @@ struct regmap *__regmap_init(struct device *dev,
 	} else {
 		if ((bus && bus->fast_io) ||
 		    config->fast_io) {
-			spin_lock_init(&map->spinlock);
-			map->lock = regmap_lock_spinlock;
-			map->unlock = regmap_unlock_spinlock;
-			lockdep_set_class_and_name(&map->spinlock,
-						   lock_key, lock_name);
+			if (config->use_raw_spinlock) {
+				raw_spin_lock_init(&map->raw_spinlock);
+				map->lock = regmap_lock_raw_spinlock;
+				map->unlock = regmap_unlock_raw_spinlock;
+				lockdep_set_class_and_name(&map->raw_spinlock,
+							   lock_key, lock_name);
+			} else {
+				spin_lock_init(&map->spinlock);
+				map->lock = regmap_lock_spinlock;
+				map->unlock = regmap_unlock_spinlock;
+				lockdep_set_class_and_name(&map->spinlock,
+							   lock_key, lock_name);
+			}
 		} else {
 			mutex_init(&map->mutex);
 			map->lock = regmap_lock_mutex;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 83a7485de78fb..418f8ce1e1dc2 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -350,6 +350,7 @@ typedef void (*regmap_unlock)(void *);
  * @ranges: Array of configuration entries for virtual address ranges.
  * @num_ranges: Number of range configuration entries.
  * @use_hwlock: Indicate if a hardware spinlock should be used.
+ * @use_raw_spinlock: Indicate if a raw spinlock should be used.
  * @hwlock_id: Specify the hardware spinlock id.
  * @hwlock_mode: The hardware spinlock mode, should be HWLOCK_IRQSTATE,
  *		 HWLOCK_IRQ or 0.
@@ -416,6 +417,7 @@ struct regmap_config {
 	unsigned int num_ranges;
 
 	bool use_hwlock;
+	bool use_raw_spinlock;
 	unsigned int hwlock_id;
 	unsigned int hwlock_mode;
 
-- 
2.53.0



