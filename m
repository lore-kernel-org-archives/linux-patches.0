Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB76FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF0CC433EF;
	Tue, 10 Jan 2023 18:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375464;
	bh=k2p0wLgOJekaqvxa8FWqsgSF155bCm7gIvZUKf5Av/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P26e6OpQ+HSd4dD+bLsSFLePqtuUtCw/dCki27jLk9+W0II/vgLwDX0SyzPaVrzBE
	 5A9Q5o1uTj93JLNkKnytXiKvVxJ0XGWOKFGUOn3A0b0vz681ukmk6fWKUnR+IkEqFB
	 SR29CvEV9p9UL2BgvzR/5FOscZxvhF0m4MBWKG/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Ramalingam C <ramalingam.c@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/290] drm/i915/migrate: fix length calculation
Date: Tue, 10 Jan 2023 19:04:48 +0100
Message-Id: <20230110180038.726585526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 31d70749bfe110593fbe8bf45e7c7788c7d85035 ]

No need to insert PTEs for the PTE window itself, also foreach expects a
length not an end offset, which could be gigantic here with a second
engine.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Ramalingam C <ramalingam.c@intel.com>
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211206112539.3149779-3-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index fb7fe3a2b6c6..5b59a6effc20 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -133,7 +133,7 @@ static struct i915_address_space *migrate_vm(struct intel_gt *gt)
 			goto err_vm;
 
 		/* Now allow the GPU to rewrite the PTE via its own ppGTT */
-		vm->vm.foreach(&vm->vm, base, base + sz, insert_pte, &d);
+		vm->vm.foreach(&vm->vm, base, d.offset - base, insert_pte, &d);
 	}
 
 	return &vm->vm;
-- 
2.35.1



