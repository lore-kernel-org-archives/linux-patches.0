Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59546B8
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B1BC433C8;
	Sun,  9 Jul 2023 11:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901269;
	bh=Exg2umoa2RAIPiqQWbX4vIcq/IpYSk0UO2K02rH4ug0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcxHT1EGh/FN6usYPydpWa2MPJa8wzHFE3ycoH+vYu2IfWFvIedrQLunSuJ2HwtJ/
	 vXyA9HdoUPt0pceZDYH4buyKIAauj/8PiKil+NwiwKF0tHeXD1cP6vPo7qyw7cF9wE
	 So5PKF+0FckqlWBAk5gXk/KuQFNhQRmYDheSTRFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.4 2/8] mm: lock a vma before stack expansion
Date: Sun,  9 Jul 2023 13:14:08 +0200
Message-ID: <20230709111345.373476152@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111345.297026264@linuxfoundation.org>
References: <20230709111345.297026264@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suren Baghdasaryan <surenb@google.com>

commit c137381f71aec755fbf47cd4e9bd4dce752c054c upstream.

With recent changes necessitating mmap_lock to be held for write while
expanding a stack, per-VMA locks should follow the same rules and be
write-locked to prevent page faults into the VMA being expanded. Add
the necessary locking.

Cc: stable@vger.kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1975,6 +1975,8 @@ static int expand_upwards(struct vm_area
 		return -ENOMEM;
 	}
 
+	/* Lock the VMA before expanding to prevent concurrent page faults */
+	vma_start_write(vma);
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_lock in read mode.  We need the
@@ -2062,6 +2064,8 @@ int expand_downwards(struct vm_area_stru
 		return -ENOMEM;
 	}
 
+	/* Lock the VMA before expanding to prevent concurrent page faults */
+	vma_start_write(vma);
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_lock in read mode.  We need the


