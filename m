Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1DF1BDA95;
	Thu, 30 Jan 2025 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246794; cv=none; b=XP3zjsUD8igFOgzAd2VG1aL2jNeCK27tnQY48jJ0G6GGi9lTP5NVC4L+2UaeWyqk8Jm0WKwKaDoKl9gqfxx6w6Fre3g0CrrNkoqoxW+SsMN3TLNklYn5xh2j/Qpn02uIX3tF9I6I4D0qvHswTN1qOhPtv0pirLQpwZxzEUgDvo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246794; c=relaxed/simple;
	bh=TYN1mia7HSXR3MdAdta+9rzchaAhXo9ErAWj4SlXXTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFnBkcU3W+491QY10x1Ue93j0Wqaow87EQw05nU9wAbc4jLkxLhMktEqpM3NhXUzPkBISppXcBJ6Mo/eI28E99Zuex5v7QHfx1tnI2PgVlPSDu3PoZjUgy/Ncl6vYsYwVWHAKF4NdCdh3t1A73DBdhzE1NLh2AHhs3WXav7Z+PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW/7Xbt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW/7Xbt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB598C4CED2;
	Thu, 30 Jan 2025 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246794;
	bh=TYN1mia7HSXR3MdAdta+9rzchaAhXo9ErAWj4SlXXTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW/7Xbt/GSD6Mltq5ILBZCFEYJSGKM0o+x+SaRelcXLWf7NwHIZlIrv4QeUFcE3Rg
	 y4aqWgrcN8cG1OO+Kq7rh+VML9Hh2GooBLkf6sJTew/oVIW1j4EwTtYTrq7ETLHYa5
	 wuz8V8VS22qGLJYtC2uZTjGxURbcajOEqCXrnt9k=
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
Subject: [PATCH 5.4 69/91] fs/proc: fix softlockup in __read_vmcore (part 2)
Date: Thu, 30 Jan 2025 15:01:28 +0100
Message-ID: <20250130140136.450883098@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -397,6 +397,8 @@ static ssize_t __read_vmcore(char *buffe
 			if (buflen == 0)
 				return acc;
 		}
+
+		cond_resched();
 	}
 
 	return acc;


