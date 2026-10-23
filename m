Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774686;
	b=YZtJsiQwVvn0If16+Pnq7MdIFRxQzOjA3H6/LhwSZwuGewciG6BPjPthfCy8CQvRpbo/
	 HMdgmUNTyXkTJsZvo/TgK6idPOEjh3Bfk3NOcNq0vwCtuSJbR5FLhrjpgUPXX8B8sZZRS
	 6mp+PbpPMlzZ+LqkNbcVhGI/pUVUTcWkZuRAqWs/xDng9yTJrYECYGzlAOT7cKriccp3r
	 61+pLue+ArmHId1LMtnAuof0FVNC4WOZnRyeJsZ0dSAVNTG2JQ0ADNcPoi5STKwI2jNYh
	 KK/stbhWW1EM04E36DVookvHrFSB9XPScayPDkGqKXHFP6b1A8NqXc0bRKg+/JcGquQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JJ7shCIwaikpfRnRpheyPKWspDD/yOnO8SEhEsEbvzE=;
	b=HVvuv6ejMK9Kj3GkR+/8n/If6w4gka8TJS3PswJZAKoyxI52Vv6QwdnTGROtN+WnlmLw
	 qTuRJWJJOOw6imsnOUCl1audHMItTA6TWOgl81F7Lp6KwYFe8fp4iRd1ynOXhfEyHuX0S
	 sY4iG9cpU8kSv6TMAQdP29Qpw7nBIVSDfQ20QKwRaL6zLvxqX2rkP4/uydPUdugA/iu/0
	 j2qcDd1mdr/XHicEXEEUjB5slo+v7sopcIZjGE8ezdAKsUHfw2jXLr45IgQF53pYmadOO
	 /t4tsTJJRCBolW16uyCuzRTw451ymBTJu3i7yyXQLz6JGLxEu8uL3TkjVKGZCy8TG2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G4ASk3/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11335606A31A;
	Fri, 23 Oct 2026 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4ASk3/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE901F01825;
	Fri, 23 Oct 2026 16:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774685;
	bh=JJ7shCIwaikpfRnRpheyPKWspDD/yOnO8SEhEsEbvzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4ASk3/LEdauKvHiqwp2ouJNN8lL1TjS3h6NcXvmEPEfi670VHgV0ILfRau9Xj/L4
	 ROwPM5lQG5+0zWJeADh5aiftIX+eWwksgKPKubJP6vmTqruTwiUxxxsCvupUysDatE
	 tSuNY1PoYetiSzyl8Zn4Q1NOY+IvvzTm8Dqw0xhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Garg <hargar@linux.microsoft.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 7.2 123/242] mshv_vtl: Check per-CPU register page before mmap
Date: Fri, 23 Oct 2026 18:39:25 +0200
Message-ID: <20261023163716.690338490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Garg <hargar@linux.microsoft.com>

commit 874194a8de75fc2f4d1fb70c670b289b7e48f93e upstream.

Register-page setup is optional for each CPU. If allocation or
registration fails, mshv_vtl_configure_reg_page() warns and leaves that
CPU's reg_page NULL, but initial context setup continues successfully.
Meanwhile, successful setup on another CPU sets the global
mshv_has_reg_page flag.

mshv_vtl_fault() checks this global flag before selecting the requested
CPU's register page. With mixed setup results across online CPUs, the
check passes even for a CPU with no register page, reaching
get_page(NULL) when userspace faults in that mapping.

Check the selected per-CPU register page before taking its reference and
return VM_FAULT_SIGBUS if it is absent.

Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/mshv_vtl_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -819,6 +819,9 @@ static vm_fault_t mshv_vtl_fault(struct
 		return VM_FAULT_NOPAGE;
 	}
 
+	if (!page)
+		return VM_FAULT_SIGBUS;
+
 	get_page(page);
 	vmf->page = page;
 


