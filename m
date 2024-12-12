Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED520E034;
	Thu, 12 Dec 2024 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016619; cv=none; b=co5gDByN7yJRDqHwGefHB3eWLDnoka9XTUt9NuNSti7OvST9ouDcoMM4JwfLL32JTld/BOWBFl4O7mTQjcNORtxoSYFetxeW8tardJsaz8OkgPvNUBoKrDJlrONBrKYvw2atkqKuP0bOrVv+QelltG9tHAeA9WazQ98YdqR4zh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016619; c=relaxed/simple;
	bh=MUMv6rRnScSBqJsgjPGrE6nq8faNTUDm4eOp/ekda8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwXQMItYlCIVas3CO9bzjqVeSYAw+zAiPiqTAE7GIJXJjZlxBRH6L0+4+Fy0wbw8W/hO81Sjjup3THHU6RXCD06mzFkwAlQBMKwATsxB1NRVywwPF/oFsnwWwLpmyfNqXqjE5Peqpw+QxNya0olBTsTMG/aby+7bDpQJNYcLI0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arp1ciWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arp1ciWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF46C4CED0;
	Thu, 12 Dec 2024 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016619;
	bh=MUMv6rRnScSBqJsgjPGrE6nq8faNTUDm4eOp/ekda8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arp1ciWq6rblrs7G9ouD5eQAKLpwp13FtrwSySEmCHDy34VpOU0Ae8jOojaEsEYME
	 q1J5ek8Bbkyfk2Ix2oKMLasA1rQeXJfA5ebA9wgL4UnbfNn/JrxxsfmtRJCuS33FAq
	 USrqm693CwswXWBz6SJrS91k2weIVsuaTYvbPuvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/466] regmap: maple: Provide lockdep (sub)class for maple trees internal lock
Date: Thu, 12 Dec 2024 15:56:58 +0100
Message-ID: <20241212144316.624428153@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 1ed9b927e7dd8b8cff13052efe212a8ff72ec51d ]

In some cases when using the maple tree register cache, the lockdep
validator might complain about invalid deadlocks:

[7.131886]  Possible interrupt unsafe locking scenario:

[7.131890]        CPU0                    CPU1
[7.131893]        ----                    ----
[7.131896]   lock(&mt->ma_lock);
[7.131904]                                local_irq_disable();
[7.131907]                                lock(rockchip_drm_vop2:3114:(&vop2_regmap_config)->lock);
[7.131916]                                lock(&mt->ma_lock);
[7.131925]   <Interrupt>
[7.131928]     lock(rockchip_drm_vop2:3114:(&vop2_regmap_config)->lock);
[7.131936]
                *** DEADLOCK ***

[7.131939] no locks held by swapper/0/0.
[7.131944]
               the shortest dependencies between 2nd lock and 1st lock:
[7.131950]  -> (&mt->ma_lock){+.+.}-{2:2} {
[7.131966]     HARDIRQ-ON-W at:
[7.131973]                       lock_acquire+0x200/0x330
[7.131986]                       _raw_spin_lock+0x50/0x70
[7.131998]                       regcache_maple_write+0x68/0xe0
[7.132010]                       regcache_write+0x6c/0x90
[7.132019]                       _regmap_read+0x19c/0x1d0
[7.132029]                       _regmap_update_bits+0xc0/0x148
[7.132038]                       regmap_update_bits_base+0x6c/0xa8
[7.132048]                       rk8xx_probe+0x22c/0x3d8
[7.132057]                       rk8xx_spi_probe+0x74/0x88
[7.132065]                       spi_probe+0xa8/0xe0

[...]

[7.132675]   }
[7.132678]   ... key      at: [<ffff800082943c20>] __key.0+0x0/0x10
[7.132691]   ... acquired at:
[7.132695]    _raw_spin_lock+0x50/0x70
[7.132704]    regcache_maple_write+0x68/0xe0
[7.132714]    regcache_write+0x6c/0x90
[7.132724]    _regmap_read+0x19c/0x1d0
[7.132732]    _regmap_update_bits+0xc0/0x148
[7.132741]    regmap_field_update_bits_base+0x74/0xb8
[7.132751]    vop2_plane_atomic_update+0x480/0x14d8 [rockchipdrm]
[7.132820]    drm_atomic_helper_commit_planes+0x1a0/0x320 [drm_kms_helper]

[...]

[7.135112] -> (rockchip_drm_vop2:3114:(&vop2_regmap_config)->lock){-...}-{2:2} {
[7.135130]    IN-HARDIRQ-W at:
[7.135136]                     lock_acquire+0x200/0x330
[7.135147]                     _raw_spin_lock_irqsave+0x6c/0x98
[7.135157]                     regmap_lock_spinlock+0x20/0x40
[7.135166]                     regmap_read+0x44/0x90
[7.135175]                     vop2_isr+0x90/0x290 [rockchipdrm]
[7.135225]                     __handle_irq_event_percpu+0x124/0x2d0

In the example above, the validator seems to get the scope of
dependencies wrong, since the regmap instance used in rk8xx-spi driver
has nothing to do with the instance from vop2.

Improve validation by sharing the regmap's lockdep class with the maple
tree's internal lock, while also providing a subclass for the latter.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20241031-regmap-maple-lockdep-fix-v2-1-06a3710f3623@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/internal.h       | 1 +
 drivers/base/regmap/regcache-maple.c | 3 +++
 drivers/base/regmap/regmap.c         | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 83acccdc10089..bdb450436cbc5 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -59,6 +59,7 @@ struct regmap {
 			unsigned long raw_spinlock_flags;
 		};
 	};
+	struct lock_class_key *lock_key;
 	regmap_lock lock;
 	regmap_unlock unlock;
 	void *lock_arg; /* This is passed to lock/unlock functions */
diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 8d27d3653ea3e..23da7b31d7153 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -355,6 +355,9 @@ static int regcache_maple_init(struct regmap *map)
 
 	mt_init(mt);
 
+	if (!mt_external_lock(mt) && map->lock_key)
+		lockdep_set_class_and_subclass(&mt->ma_lock, map->lock_key, 1);
+
 	if (!map->num_reg_defaults)
 		return 0;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7ef8577aeb100..e3e2afc2c83c6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -756,6 +756,7 @@ struct regmap *__regmap_init(struct device *dev,
 						   lock_key, lock_name);
 		}
 		map->lock_arg = map;
+		map->lock_key = lock_key;
 	}
 
 	/*
-- 
2.43.0



