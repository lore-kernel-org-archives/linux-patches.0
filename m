Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857330CD9F;
	Fri, 17 Oct 2025 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714472; cv=none; b=A/q+4pao2bUrT6EuXpnuTIlaxqetvR+9kZf9iZ2HaA36yt3jG4iFJ6OiaQTtozMJCKDltk0EZGy3RAf0fl/rmr3jn7nyhN0yjUeVWonkcUUTVZkQYRvCGmDtvMAtJvSH7C6KQc/RJWwwgE9aAsv2vs9BKlzn2NiECJV0/DCjDUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714472; c=relaxed/simple;
	bh=F14BSajSHTU+rpf+/HMl7Yyo2DU9K8KIsRCRUDirGdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQmRMrDpSo8ZUTfIcEcZK+BqWxvKaF7U2FWsetkp2fzuTPe/QGY7H3CLbW0kDEBUIRCXQOJavq7Fi0iATtAihNsnQozvSD17w+OvrfmTuqXrfY0XGjYYJ0pxN1Tlwz0p4DA6uOzunZscavWC+OcLQxYS79RCkqG3kRqCmuIUuYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SKTBt/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SKTBt/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A77DC4CEE7;
	Fri, 17 Oct 2025 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714472;
	bh=F14BSajSHTU+rpf+/HMl7Yyo2DU9K8KIsRCRUDirGdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SKTBt/XKlXWOWrfwAce0cjoWyJcpvcDRUmGEqa64nB2TK60PX/z2uGunwmiV6kui
	 tMTyXyQbp/2NA06dmavtG1fxmMoyjjl2U/nxNthxUwfKiRmkrYYATNxge6U96kz80h
	 Mg7t3L9QNvH9/HHINiPvDCdY6ZfvKYhoHCA7qA6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 157/277] powerpc/pseries/msi: Fix potential underflow and leak issue
Date: Fri, 17 Oct 2025 16:52:44 +0200
Message-ID: <20251017145152.856510413@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 3443ff3be6e59b80d74036bb39f5b6409eb23cc9 upstream.

pseries_irq_domain_alloc() allocates interrupts at parent's interrupt
domain. If it fails in the progress, all allocated interrupts are
freed.

The number of successfully allocated interrupts so far is stored
"i". However, "i - 1" interrupts are freed. This is broken:

  - One interrupt is not be freed

  - If "i" is zero, "i - 1" wraps around

Correct the number of freed interrupts to 'i'.

Fixes: a5f3d2c17b07 ("powerpc/pseries/pci: Add MSI domains")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/a980067f2b256bf716b4cd713bc1095966eed8cd.1754300646.git.namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -592,7 +592,7 @@ static int pseries_irq_domain_alloc(stru
 
 out:
 	/* TODO: handle RTAS cleanup in ->msi_finish() ? */
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 	return ret;
 }
 


