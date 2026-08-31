Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9102247F2F9;
	Mon, 31 Aug 2026 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185068; cv=none; b=H4ZjIvVjkkkBNAmRA48Uw5h7T8LjfbpBv0jCjtMVf/z5ZFnZ9stdV+DKdjxGydF53+en29JDqNtZDX7mnf5f4P6KtwD8rAIUTLpDJtwVlMW0yE+UwJ/af2TTTbnTPMOYa3SSlO6mKnZqeTpVDX34dl+ZlHQlcFYC/yPSkJlvmj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185068; c=relaxed/simple;
	bh=UTKy5ynPhntOQPYYR0JcUupZfiCCQ+T75zauvFFFl4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEAMqtURMZUXhOMfVn71X5t1VIQxLGGKql4oa9kPmvP+TQ5lHkwBCn38AakAhs0dGr26KQBARd5GNR7BDbF1OfQlu9EIv1P7ApDZThVhKK0V7pvDUajhsaqXnUuI+Nvs5bPweJNsFnkDfww8zh5r6z2Zy+GAIfJkI+aW5IDAsuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFj+7y1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFj+7y1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB6F1F000E9;
	Mon, 31 Aug 2026 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185067;
	bh=Q7MN4hdBLWViIEfn0kDz0zLBvJxuOV7Shf6PwcQpsdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFj+7y1QllYIfpe2ZVIYx/Oz+RZHlJO/bLAX8QOx+NjHPh6noNTP6lKSifQTOFL6R
	 YhDv2RHReN803IoDRNDVAxJ2eLf6+2Th7sY1QQ62T9H/ZjsSQG8wuz4zmiKYaazfLC
	 7hPym+r+E/pWvU9nDc7yCuv2XJwrzGX3QA3dSEhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.15 43/69] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:35:16 +0200
Message-ID: <20260831133400.732404040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit a76acbaec9b8fd74413646984d2e3626d0543e39 upstream.

The ldisc registration is intentionally non-fatal, since some synth
drivers do not use tty/ldisc.  However, once speakup_init() continues
past the registration point and later fails, the init unwind path should
mirror speakup_exit() and call spk_ttyio_unregister_ldisc().

Add the missing unregister call to the error path after synth_release(),
matching the normal module exit cleanup order.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: e23a9b439ce9 ("staging: speakup: safely register and unregister ldisc")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260531230804.254962-16-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -2430,6 +2430,7 @@ error_kbdnotifier:
 	mutex_lock(&spk_mutex);
 	synth_release();
 	mutex_unlock(&spk_mutex);
+	spk_ttyio_unregister_ldisc();
 	speakup_kobj_exit();
 
 error_kobjects:


