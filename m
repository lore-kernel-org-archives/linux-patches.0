Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7680216F8FA;
	Wed,  3 Jul 2024 11:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005565; cv=none; b=UJx8h8yl7JZGNjSqOEGbXIG2VFHWrTHKv7m82bWZrvw9WEreWfqKd7ul3SCEHZ4quvM5jrL7pQ97IU+lXjNNAo/JT5Vv8mTRI23qe17D/Xvf8AJkLCcff9gVxGNl51lQWH4xxeW6MdJeoqVpG4l0bAjsnW9EmwaDBnvVnWqlDXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005565; c=relaxed/simple;
	bh=6Ie7//itDiqbtXgs/4FKgqB11AeT/zgcaotSQz4w32A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSTSpI8DxHhxV+eMjrmUJJH1CdF7UEW6Iyj8XHy0P4OO7sd9tua1K385kfFszKKwmmmmIoVLr/xo2IO5NNiaBclg1o0YVFjFeb5bBjKl5LkDZHP9E75mPPnkLwKyiI7uxYNKyQMNX0NHPCETYdZlr68yF5FCYWwZt6/BEVWaFlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Am3XUKeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Am3XUKeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D7BC2BD10;
	Wed,  3 Jul 2024 11:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005565;
	bh=6Ie7//itDiqbtXgs/4FKgqB11AeT/zgcaotSQz4w32A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am3XUKeIlA1S+PzsjHTYtgtXR6Jbosza2VglL5VngiaAaJJhbsvWh5EAE/mP+XXqu
	 JnjnkJ0QCZdof3O3MrL38LtBJ/3xf9KNEMosX4tx2n3aqA0FRL9C9Fj72Joe646Cxd
	 +KGT5eNecWjOYc0LR+pqlKVXTnDXFlY1LM4G8z5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 124/356] fs/proc: fix softlockup in __read_vmcore
Date: Wed,  3 Jul 2024 12:37:40 +0200
Message-ID: <20240703102917.786065095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit 5cbcb62dddf5346077feb82b7b0c9254222d3445 upstream.

While taking a kernel core dump with makedumpfile on a larger system,
softlockup messages often appear.

While softlockup warnings can be harmless, they can also interfere with
things like RCU freeing memory, which can be problematic when the kdump
kexec image is configured with as little memory as possible.

Avoid the softlockup, and give things like work items and RCU a chance to
do their thing during __read_vmcore by adding a cond_resched.

Link: https://lkml.kernel.org/r/20240507091858.36ff767f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -373,6 +373,8 @@ static ssize_t __read_vmcore(char *buffe
 		/* leave now if filled buffer already */
 		if (buflen == 0)
 			return acc;
+
+		cond_resched();
 	}
 
 	list_for_each_entry(m, &vmcore_list, list) {


