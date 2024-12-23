Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96103D6D;
	Mon, 23 Dec 2024 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970125; cv=none; b=YivgAr4W5gzpoe+QHc4QAOig1Ye1a0nprK8nEkGMv/EAVtyO5OgfX0ojXscqog7k1JTVyI+J2qT+H/jdJNLUSjf9E28STSUvq4QvgOHegn4gFsw+3iMUcqW8elES2z3ttXmUgcyx9MXJOoofkfm/5VdfjWc4ohFDGXRnXxFPwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970125; c=relaxed/simple;
	bh=eiT3Jap8GrEEMZS1Z+JnJbeR08vSggWLQFtDIJMGSlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIZaFNrmb0jhlbe8OwVRyaO9LtyYiSpDxrVnIsNaC2Cyti+oxTlBjeEBt2o3TwYinnM+wNiFtPgvv8H3WrK6dN/820DWlxJT+kuX0prjcDVfdwwB5cOrTrvw2HpQc+U0h5ul57S5f2Nd5KTexXJgekXsCC3JML4vdcxpmMNWMWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFONzzJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFONzzJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6FDC4CED3;
	Mon, 23 Dec 2024 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970125;
	bh=eiT3Jap8GrEEMZS1Z+JnJbeR08vSggWLQFtDIJMGSlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFONzzJWHoVUkYlUQn6+LsWOv55wZA3otGDxacPjmaFdsMhF45esVlmmyyQMbSpt3
	 uvllJAWJPlWoJQJizM4cwKhqzSQPN3x1wCjFfi8zZ83ixdvP43ecwYWqDIpRnn87do
	 /04TPDtDO7G1jEMQq413yNQZBEw35q0CIGha24tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Jann Horn <jannh@google.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 6.12 145/160] udmabuf: fix racy memfd sealing check
Date: Mon, 23 Dec 2024 16:59:16 +0100
Message-ID: <20241223155414.407956911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 9cb189a882738c1d28b349d4e7c6a1ef9b3d8f87 upstream.

The current check_memfd_seals() is racy: Since we first do
check_memfd_seals() and then udmabuf_pin_folios() without holding any
relevant lock across both, F_SEAL_WRITE can be set in between.
This is problematic because we can end up holding pins to pages in a
write-sealed memfd.

Fix it using the inode lock, that's probably the easiest way.
In the future, we might want to consider moving this logic into memfd,
especially if anyone else wants to use memfd_pin_folios().

Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219106
Closes: https://lore.kernel.org/r/CAG48ez0w8HrFEZtJkfmkVKFDhE5aP7nz=obrimeTgpD+StkV9w@mail.gmail.com
Fixes: fbb0de795078 ("Add udmabuf misc device")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-1-23887289de1c@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -394,14 +394,19 @@ static long udmabuf_create(struct miscde
 			goto err;
 		}
 
+		/*
+		 * Take the inode lock to protect against concurrent
+		 * memfd_add_seals(), which takes this lock in write mode.
+		 */
+		inode_lock_shared(file_inode(memfd));
 		ret = check_memfd_seals(memfd);
-		if (ret < 0) {
-			fput(memfd);
-			goto err;
-		}
+		if (ret)
+			goto out_unlock;
 
 		ret = udmabuf_pin_folios(ubuf, memfd, list[i].offset,
 					 list[i].size);
+out_unlock:
+		inode_unlock_shared(file_inode(memfd));
 		fput(memfd);
 		if (ret)
 			goto err;


