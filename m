Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88731E522;
	Thu, 30 Jan 2025 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247159; cv=none; b=JO/59GrnjZHJFaHirwHTeMCCbwiXDkLodk8RZYqrejgEOmtspY7IoiXpiH0scxD2RSbKlf2D2L34IPovFZdlbjE+tQWKrPI+5ucbvYLL/OqOEtOXn3tPfBfxLpq9P9SS+9FOt16QF3Ug4B73sJqDhrvAXzdHibpsnTjakA3b6Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247159; c=relaxed/simple;
	bh=O4OAZmX0+AE/yf3+6Z8MCqWrKvPk+8IGB8FuOxR05JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9OSnl1bCyuedBBNNBo8iy8jA8s41j0E4YiQ9gfAx66rDacFV55lh7S5HmJYbhdoPcfgKtmhs0u1YYc+vrweQffUGMMdN28stdP/i/1DbU/aR/5xe/WZSFOQa0XEq3+2nRkJt85Kex3SN5MMCYKQiyh3CylMvBP1JT2plW3AYRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC80XJ1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC80XJ1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5253CC4CED2;
	Thu, 30 Jan 2025 14:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247159;
	bh=O4OAZmX0+AE/yf3+6Z8MCqWrKvPk+8IGB8FuOxR05JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC80XJ1JIiacaRnyJTIg0EejD1aXGzWqqG1jFpA02G/z0iFymquGNrLGziXBAlClR
	 1spvItWAp6H1+dIb58RpXmZKJ2hHhOTIljyvW+lxyxEZgv3W+kwwnCERGdNwuTpCNi
	 zTK/PwKnJcKWjsZUTQL30RzZNYYaoB4Lg4940ffc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Breno Leitao <leitao@debian.org>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 095/133] fs/proc: fix softlockup in __read_vmcore (part 2)
Date: Thu, 30 Jan 2025 15:01:24 +0100
Message-ID: <20250130140146.354651512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rik van Riel <riel@surriel.com>

commit cbc5dde0a461240046e8a41c43d7c3b76d5db952 upstream.

Since commit 5cbcb62dddf5 ("fs/proc: fix softlockup in __read_vmcore") the
number of softlockups in __read_vmcore at kdump time have gone down, but
they still happen sometimes.

In a memory constrained environment like the kdump image, a softlockup is
not just a harmless message, but it can interfere with things like RCU
freeing memory, causing the crashdump to get stuck.

The second loop in __read_vmcore has a lot more opportunities for natural
sleep points, like scheduling out while waiting for a data write to
happen, but apparently that is not always enough.

Add a cond_resched() to the second loop in __read_vmcore to (hopefully)
get rid of the softlockups.

Link: https://lkml.kernel.org/r/20250110102821.2a37581b@fangorn
Fixes: 5cbcb62dddf5 ("fs/proc: fix softlockup in __read_vmcore")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
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
@@ -396,6 +396,8 @@ static ssize_t __read_vmcore(char *buffe
 			if (buflen == 0)
 				return acc;
 		}
+
+		cond_resched();
 	}
 
 	return acc;


