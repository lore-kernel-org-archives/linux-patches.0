Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619E3BF2FF;
	Thu, 15 Jan 2026 17:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498098; cv=none; b=NBL3k1I3QFao1cOn33JluQxNhYigmus/3ZAs8uVhHfe/ZF6PPk3q22lnQ+j9pfNEhLwag0HwKXSIowvJVaQFZkXc5kFQuamzL1cLSTPwd4HP5onxhr8Mf7WtLMX9M7brjEZj7h2qca9My7zRaOo2+S8h6/vImRNmb149edq6748=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498098; c=relaxed/simple;
	bh=CIgom2USfIawX/+65QpwSkay18ttvhkupV/MKscZ/So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZOknRweyVlV83oxLurNTPG69dQFK0UuqRHxsdU/ihD+cpmpeM/2AjDC8xnFV3+uAfwAdKvP3YySA1G7BfPEWMk/Q+8stOjjDTyU8+31lhAO25daDTJ+Z7eoNql0s5+xfCUlZMMSb57oJSHO6comN5BLjjNttpQZp+5jJ9tYlP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEjCFonQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEjCFonQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DECCC116D0;
	Thu, 15 Jan 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498098;
	bh=CIgom2USfIawX/+65QpwSkay18ttvhkupV/MKscZ/So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEjCFonQ/7UFE/cGio8nc007g2B94bcq74X4yHCq2ENcaMgBdokn/EIWJEyQZ0oKX
	 vsWWVn2zpyz6uRbq2VOaGMM6H8Bjjf9H4os6Txb+oQVERRTY3LDiBwvuE+NqRz3HXP
	 nji2FZjDu5OG4Vh6JFizD1Xr38r5DSLcy6yjiXVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 279/554] block: rate-limit capacity change info log
Date: Thu, 15 Jan 2026 17:45:45 +0100
Message-ID: <20260115164256.329207725@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <chenl311@chinatelecom.cn>

commit 3179a5f7f86bcc3acd5d6fb2a29f891ef5615852 upstream.

loop devices under heavy stress-ng loop streessor can trigger many
capacity change events in a short time. Each event prints an info
message from set_capacity_and_notify(), flooding the console and
contributing to soft lockups on slow consoles.

Switch the printk in set_capacity_and_notify() to
pr_info_ratelimited() so frequent capacity changes do not spam
the log while still reporting occasional changes.

Cc: stable@vger.kernel.org
Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -83,7 +83,7 @@ bool set_capacity_and_notify(struct gend
 	    (disk->flags & GENHD_FL_HIDDEN))
 		return false;
 
-	pr_info("%s: detected capacity change from %lld to %lld\n",
+	pr_info_ratelimited("%s: detected capacity change from %lld to %lld\n",
 		disk->disk_name, capacity, size);
 
 	/*


