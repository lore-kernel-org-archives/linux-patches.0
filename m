Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D12B1AF0AB;
	Tue, 15 Oct 2024 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997660; cv=none; b=G+u1LdsavJadn/7e3bGe4GD1KUZdW9bVsvfeRbdUpoQeVN5MdjL+gvvjhmI50AKXtoXOs++m/vv+pZrpXf5G8pYTR0fwVb/iOuxJxGCF51Zik5BMunetBxJZla6SHpAU8kJy57XpghOnAOS2tq1ubhtFAB37asCqTZRRw1gGOQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997660; c=relaxed/simple;
	bh=TI6DfyT3uSrSRD5wpmGNX3K5IaREmPl/Zfo0vLdmhRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPh6slyT1kEQ8RpQDoRUFIzyE4Xns0S1Czm/R1cv75b+z8dQb+WJZgGOonqqj+MenVq3TZ5RJfULCUnbPEMaFOFWKgkLr9n15YWRg5A2SD8dFFor05IHqeukDBnE2sfnC0TeJ6XWO+kwBM0DhAbPi/tQT6vCFF9LR/yjfTM6Z1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCuvNgKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCuvNgKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6583C4CEC6;
	Tue, 15 Oct 2024 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997660;
	bh=TI6DfyT3uSrSRD5wpmGNX3K5IaREmPl/Zfo0vLdmhRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCuvNgKjF4vaTrhPmotcwAGnk+qQnxpwemlVz2uHlQJb8jcJ8MDPkHHJl7VcdQUMN
	 1BlWENF2MqwunUZg0MpWLT79tEnC/kWFcMe8ZiuezP+T7EbnCm+HR7sKLhwHWGOPWA
	 /Z01gtANYKLYIL33jnhXw/5sjHNdlBp3PeFJtk7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gafert <christian.gafert@rohde-schwarz.com>,
	Max Ferger <max.ferger@rohde-schwarz.com>,
	Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 248/518] padata: use integer wrap around to prevent deadlock on seq_nr overflow
Date: Tue, 15 Oct 2024 14:42:32 +0200
Message-ID: <20241015123926.563657551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>

commit 9a22b2812393d93d84358a760c347c21939029a6 upstream.

When submitting more than 2^32 padata objects to padata_do_serial, the
current sorting implementation incorrectly sorts padata objects with
overflowed seq_nr, causing them to be placed before existing objects in
the reorder list. This leads to a deadlock in the serialization process
as padata_find_next cannot match padata->seq_nr and pd->processed
because the padata instance with overflowed seq_nr will be selected
next.

To fix this, we use an unsigned integer wrap around to correctly sort
padata objects in scenarios with integer overflow.

Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")
Cc: <stable@vger.kernel.org>
Co-developed-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Signed-off-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Co-developed-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -409,7 +409,8 @@ void padata_do_serial(struct padata_priv
 	/* Sort in ascending order of sequence number. */
 	list_for_each_prev(pos, &reorder->list) {
 		cur = list_entry(pos, struct padata_priv, list);
-		if (cur->seq_nr < padata->seq_nr)
+		/* Compare by difference to consider integer wrap around */
+		if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
 			break;
 	}
 	list_add(&padata->list, pos);


