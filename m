Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6E43DE44A;
	Mon,  4 May 2026 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903616; cv=none; b=gkYrPF3E5BT7ujsymaxnvBh6Q8mtrYVKa5pu7sj/SS+F+FDFI4HF4lXQp8Zj+6iQfnqtcYq9MFWbddceuUBHJCVtZhjKojsb61Eu8Aqrj1nMXNyZPSuDYZ7mwa5vNyX3s6AhrOb+Ob2BhncNdPvDHoFtwyKfr/WkDdhgqEwcR/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903616; c=relaxed/simple;
	bh=lRCeTMOZq5Rthb+rmv2xshgSVz3OBhPQNzcMhy9Psnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzEdLG21Z4cOYAkETepQY33AuGfLeUfUie72W48OObe+kv9x8iar1/uYykHAWD8baYPI2BJWADOtGHgv5DS9Mwh4e+j3H6zclxir1H37quUfXoGwbP9KrEU+hmpKR6D/P/dU4FN1GE9KnRKL8mbuokn5HhXeYuQW7V19r7ER220=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dmx6RLti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dmx6RLti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E972DC2BCB8;
	Mon,  4 May 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903616;
	bh=lRCeTMOZq5Rthb+rmv2xshgSVz3OBhPQNzcMhy9Psnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dmx6RLtiDRV01++0Zu4qoeCIL8R2r5qz+e0tb0qOSm11IR3N9xkcrUvw7WJLBsXnf
	 VgumMi5Gi/DX3Haw/SQuCxNtpp4bnAcOi8oK6lRFPn9ueuJnUV3MqV06NyYGVpRPaP
	 1ecJCKXU1gmNccfvX4jGvVvL8EP0k8SVtOKQbxas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 303/307] vmalloc: fix buffer overflow in vrealloc_node_align()
Date: Mon,  4 May 2026 15:53:08 +0200
Message-ID: <20260504135154.175645089@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4361,7 +4361,7 @@ need_realloc:
 		return NULL;
 
 	if (p) {
-		memcpy(n, p, old_size);
+		memcpy(n, p, min(size, old_size));
 		vfree(p);
 	}
 


