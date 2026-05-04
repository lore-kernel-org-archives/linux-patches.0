Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236451A6827;
	Mon,  4 May 2026 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904350; cv=none; b=VTXjA9olOlxNRpD3eW29zIyEUNM4yRw2YChaqYPbBq4vrmx/NJZ1xF6RpGAH3DizFrfFvGEEFgxP7GTiP35GQrNjWMDSSV2vZ3nbeOU7Y/upmVaA6tOUH/CkHUhyDQEopAUQp2JDwzwtSzGepamfhBbU38baCBehQSeeR+cl/EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904350; c=relaxed/simple;
	bh=2kG1bWUG1MLkLQYC/l6LJKzLLFcNcXM9ghFbitbXJvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixj/vIQKGdR5fCqfIcMp6/MnXHD8rFLjbbgSU+tFbHcAeH/7yOF7lB7zW8Hwkix6HIb2b3D/ViMbmSRdGgXy6LxTWY5IjKtaUbLvtgzC2ME9+lYMavMOkZIFgOrQCb78WmqoQsmxF9A+EH2u+Et1NIG7IxuhRdYVhBTMlV3AaL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM0JcJQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM0JcJQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66025C2BCB8;
	Mon,  4 May 2026 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904349;
	bh=2kG1bWUG1MLkLQYC/l6LJKzLLFcNcXM9ghFbitbXJvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM0JcJQP4qXJaT7N0Lft3MO9c1sagQRntHa28ptBGww+irzb5YwUKWMBERQ+Ou8aD
	 FPnFVWLELPBIv5Zr/tVaiYbsqV404fFvuhQ95LciNpQAqDp6kvMkNkRl8OMvprZdBs
	 nt5UJAmF08Xpz4rheJKauK3hTROp+qtvU+AigWLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 271/275] vmalloc: fix buffer overflow in vrealloc_node_align()
Date: Mon,  4 May 2026 15:53:31 +0200
Message-ID: <20260504135153.100437439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

commit 82d1f01292d3f09bf063f829f8ab8de12b4280a1 upstream.

Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
vrealloc") added the ability to force a new allocation if the current
pointer is on the wrong NUMA node, or if an alignment constraint is not
met, even if the user is shrinking the allocation.

On this path (need_realloc), the code allocates a new object of 'size'
bytes and then memcpy()s 'old_size' bytes into it.  If the request is to
shrink the object (size < old_size), this results in an out-of-bounds
write on the new buffer.

Fix this by bounding the copy length by the new allocation size.

Link: https://lore.kernel.org/20260420114805.3572606-2-elver@google.com
Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4201,7 +4201,7 @@ need_realloc:
 		return NULL;
 
 	if (p) {
-		memcpy(n, p, old_size);
+		memcpy(n, p, min(size, old_size));
 		vfree(p);
 	}
 


