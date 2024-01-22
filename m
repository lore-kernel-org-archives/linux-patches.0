Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA2365BAF;
	Tue, 23 Jan 2024 00:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971523; cv=none; b=Cnj3i12spOOPfsYgcfndToAG5NKZMTzID3MrCw6nGqk9jKdhYv7CPSKUnS+CllO1SkmHaN37uJQUXaqr09CYN+dc4bGFKKR82ULKEaqcZbglVP91YeIw5YsDNMORbNVgtVlyBiRKIdcF9UvnqbZSGlL5JmPc99cDchj9f/U3IRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971523; c=relaxed/simple;
	bh=TG51LaI3VJqXJlqKa4wiwn5MhmA6FHwfCh7FZhfvGDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fua6dEmIiHU7PEUGzlusw/7gG9gWrJJONjPet451iA+lwUiwB364AGibi9rgR9hHNH4+0JSL1H8pYdiCDb8atrpXqaQGXhWT9xkSpO7L9gdf3DJEw7k8A0BogLg0EwXrTBK1XPpZdT24pMFJg4BaxklyIQYdEO+jUH9XISUItvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrIitEOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrIitEOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FD6C433C7;
	Tue, 23 Jan 2024 00:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971523;
	bh=TG51LaI3VJqXJlqKa4wiwn5MhmA6FHwfCh7FZhfvGDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrIitEOSHsO5BNYl0wKvWJhvqcXt2yu5EJtjYUUEWXkXnaCHl7LhSucL1jMxcXhiW
	 ZhpDPYGdStA9ezPfdMINBdBJhcfYv6LJ7Ywcor5FjSihNXy4MVUJlrN77QGbiWhuYu
	 df0gTnVt/ktIEDPVG5/WhPox7FqBy1cLd5LishxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Subject: [PATCH 6.1 257/417] powerpc/64s: Increase default stack size to 32KB
Date: Mon, 22 Jan 2024 15:57:05 -0800
Message-ID: <20240122235800.776657709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 18f14afe281648e31ed35c9ad2fcb724c4838ad9 upstream.

There are reports of kernels crashing due to stack overflow while
running OpenShift (Kubernetes). The primary contributor to the stack
usage seems to be openvswitch, which is used by OVN-Kubernetes (based on
OVN (Open Virtual Network)), but NFS also contributes in some stack
traces.

There may be some opportunities to reduce stack usage in the openvswitch
code, but doing so potentially require tradeoffs vs performance, and
also requires testing across architectures.

Looking at stack usage across the kernel (using -fstack-usage), shows
that ppc64le stack frames are on average 50-100% larger than the
equivalent function built for x86-64. Which is not surprising given the
minimum stack frame size is 32 bytes on ppc64le vs 16 bytes on x86-64.

So increase the default stack size to 32KB for the modern 64-bit Book3S
platforms, ie. pseries (virtualised) and powernv (bare metal). That
leaves the older systems like G5s, and the AmigaOne (pasemi) with a 16KB
stack which should be sufficient on those machines.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Link: https://msgid.link/20231215124449.317597-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -806,6 +806,7 @@ config THREAD_SHIFT
 	int "Thread shift" if EXPERT
 	range 13 15
 	default "15" if PPC_256K_PAGES
+	default "15" if PPC_PSERIES || PPC_POWERNV
 	default "14" if PPC64
 	default "13"
 	help


