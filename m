Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D3221DA4;
	Thu, 12 Dec 2024 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025908; cv=none; b=L700R2KAgAUiF1j8rBbzuZw7eLgypFolyXKrfjpnifjhlGd+n10K6GrFTirIbUfKl+U6td2hmevP01GLe9HA0ArTcQJ0jIpmsimglGQqQtDZGGnoz37RDrgi+1vyUnglJwxxkAlEpq32DVLvtaptAIWP8rFoN6udMCGJCLrhts0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025908; c=relaxed/simple;
	bh=aXF/gpHAS3y4I6RfI2tZs/bUWxgV7ii7ctDXib3Z7wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTVQmkvfVL71BJncDAylYyLtA6HRyz/HbKjetDCh/bGnYemYD7LT2SuCAIGY7SIUz5otzlJ29J9vzGJvlEKkGTOhXMmesQp6uj7OHV4gIVgoln/YXfr7HIzGp48WcGvQWFsUxkgiM0qxZPuRHSQuCxcQEiifB08Jc4LgGxSKpFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGr5wQ8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGr5wQ8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64399C4CECE;
	Thu, 12 Dec 2024 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025907;
	bh=aXF/gpHAS3y4I6RfI2tZs/bUWxgV7ii7ctDXib3Z7wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGr5wQ8QhL3ChLY5sHDhtjeBoSWv93tyMRNa/c8LQKah35ijsNlsjiOl8XlOovto6
	 jpqbany7ki7sxVZgwHrncHwayHe3/oxsh2JefPFQQGnsVhFTPDrqdh4OjQLvTsGrDb
	 SmT/snIfZVmRQbSuJqyMkBUoYNsqcpgbExdZlWVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.4 313/321] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
Date: Thu, 12 Dec 2024 16:03:51 +0100
Message-ID: <20241212144242.347289440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunkun Jiang <jiangkunkun@huawei.com>

commit 7602ffd1d5e8927fadd5187cb4aed2fdc9c47143 upstream.

When DISCARD frees an ITE, it does not invalidate the
corresponding ITE. In the scenario of continuous saves and
restores, there may be a situation where an ITE is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ITE when DISCARD
frees an ITE.

Cc: stable@vger.kernel.org
Fixes: eff484e0298d ("KVM: arm64: vgic-its: ITT save and restore")
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Link: https://lore.kernel.org/r/20241107214137.428439-6-jingzhangos@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-its.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -854,6 +854,9 @@ static int vgic_its_cmd_handle_discard(s
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && ite->collection) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -862,7 +865,8 @@ static int vgic_its_cmd_handle_discard(s
 		vgic_its_invalidate_cache(kvm);
 
 		its_free_ite(kvm, ite);
-		return 0;
+
+		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;


