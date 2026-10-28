Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208707;
	b=QcZ0zU5edMZmWZ1dJGNsDgaMYxQeCCwYR5PJUi6G+NZnsx3QljjdMLzZ+3k0vkH9CErV
	 2psWHyYl/IQ2Iz6xq46vv62ZrudgLxDacKI1fRIzEKsd5oBeiU3TzrCfYTd9/l4dPkOlg
	 0RTY6eZAI8cnIhQfHdkcF0lPyZYjveAvmgwcdTNMs9wxbWkMCocL5gzgYvlyh5bo5rwAO
	 LpXUaT6njXvT6Gzvma8nTh0DzwD0XUArgvTYzceabdqocb+qAE2SgcT2Rx96vNfRoSCiS
	 w0XSk5mEwJgf5RFEAI4bCxM5oJ5HrBghxxU6NkpbDXemZJDRAvKQEhnHO74b5/MYKzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmNQlUoD+TwBsqTe/33BNQeIhnbJG4RCJE9a4L78LnQ=;
	b=chFyWNs9sklTsUXgnDUeVXGZss5IsM+ZNcLmZYoWKFl99N3DAiAjnoO+bf/bXc30jVW1
	 y7GJ/jXXln7uQieXtokVl45CyYjUB0m7xSNWOebyMbo9gsFyUfWW/XkSF8TgN6sFUcNzi
	 WIhQSHJ5w7zqRwQ3U7U0SMPf7G3uVENbp3OSt/HyC3Qso8zknK0mFPfSukFt3px63KFJo
	 id02xLGnx1RGlFwQXxlOQfbGaSYF9OAGuQnGppFVBmD9QmPmREICEz6pHkMmhNqEoCqBo
	 vPhIm/Jzv2fSG/acagwFT8dnD3/Q97/yoRy78vyN90fyYFIcCgXNB5xke8vf8hjR86g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUru4Xgt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F665606A31C;
	Wed, 28 Oct 2026 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUru4Xgt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18291F01825;
	Wed, 28 Oct 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208707;
	bh=VmNQlUoD+TwBsqTe/33BNQeIhnbJG4RCJE9a4L78LnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUru4XgtN3lYqlES95rurlv40bzf4rWVEV6vrB+2/jnqhpkP1lCwwS9qvp6Y6d4y1
	 trk9t/bIwfv2dlmmJLGh6RWwF5Cxafwla4cRIcocHY/L/L/JXDGKHyU9Kx52WD9lpz
	 lRiyhE0lZtFHDT42Ju1L3JVFjk7T9oNQGXRigYTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/516] kprobes: Skip disarmed probes when checking optkprobe overlap
Date: Wed, 28 Oct 2026 17:56:06 +0100
Message-ID: <20261028170008.568979148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 7a39c732a22ec4a369af9e19fbe3d666ec83eec4 ]

On x86, an optkprobe at A replaces five bytes with a jump. If a disabled
probe B is at A+2, get_optimized_kprobe() stops at B when arming a new
probe C at A+4. It leaves A optimized:

              A    A+1  A+2  A+3  A+4
  A's jump  | e9 | d0 | d1 | d2 | d3 |
  after C   | e9 | d0 | d1 | d2 | cc |

The INT3 for C overwrites the last byte of A's jump displacement, so
execution can jump to the wrong address. B can have prepared optinsns
while disarmed, but has no jump to unoptimize.

Continue past disarmed and unprepared probes to find the active optimized
probe before arming a probe in its jump.

Link: https://lore.kernel.org/all/20260930053618.104498-1-leon.hwang@linux.dev/

Fixes: afd66255b9a4 ("kprobes: Introduce kprobes jump optimization")
Cc: stable@vger.kernel.org
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
[ sashal: Adapted get_optimized_kprobe() to use unsigned long addresses with byte-wise scanning. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 46398072b5bea..4f2d0638644c8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -481,14 +481,16 @@ static int kprobe_queued(struct kprobe *p)
 static struct kprobe *get_optimized_kprobe(unsigned long addr)
 {
 	int i;
-	struct kprobe *p = NULL;
+	struct kprobe *p;
 	struct optimized_kprobe *op;
 
 	/* Don't check i == 0, since that is a breakpoint case. */
-	for (i = 1; !p && i < MAX_OPTIMIZED_LENGTH; i++)
+	for (i = 1; i < MAX_OPTIMIZED_LENGTH; i++) {
 		p = get_kprobe((void *)(addr - i));
+		/* A disabled probe can have prepared, but inactive, optinsns. */
+		if (!p || !kprobe_optready(p) || kprobe_disarmed(p))
+			continue;
 
-	if (p && kprobe_optready(p)) {
 		op = container_of(p, struct optimized_kprobe, kp);
 		if (arch_within_optimized_kprobe(op, addr))
 			return p;
-- 
2.53.0



