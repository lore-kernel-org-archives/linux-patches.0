Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A33714F9CC;
	Fri,  6 Dec 2024 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496302; cv=none; b=O9dTL546GgXta7u9EAlBUMcU3BazohT7sLNBIJSfZgZfI+3C49FdGFk6fIQJhP3T49IxjxuHEt/Tiv+8dQowxHQDf70S2y82rYJ+DVnFeoREE60QFKdA6qeptBlMiWBQHkdW183zUjqxWNYgKY+vr2C0SMPVYmClVRWpEnnji+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496302; c=relaxed/simple;
	bh=T7BJZTo5ZEIc1GMwUcsghyemBY959SSqQxxKhMvDhOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtlP5VsGnzzHMsQj1b8siOhAkyVCb78P0LOyeFl9CWQsTwiB6YMRgFKbbX9Y5dDtvuUCyt9VeTTthDE8uQ7OnxmNbL03tr5EAVxvPe56gZ73AgjB29MJi/Mn1NYnOkuSfgpPIUygpL9tK6wnlzbyOYu8ngRrizqpO/IsBWlbhAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2X/jKgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2X/jKgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E5BC4CED1;
	Fri,  6 Dec 2024 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496302;
	bh=T7BJZTo5ZEIc1GMwUcsghyemBY959SSqQxxKhMvDhOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2X/jKgQ8eNqr4ipAY6wz+dJ+43IospH98Xbxr2glfz0zsJtTNGeVOIbdOW9Z87zt
	 lWeMZ1W8sOEIg3yDG8uLWDtwfb/cNEII69de6Vaf9igPB4SoN5u6VggOFP+SzsA2QM
	 lUZi+p/oVSOryCA0AcYSnKbqgUpCkLNSBiidFawg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12 111/146] binder: fix BINDER_WORK_FROZEN_BINDER debug logs
Date: Fri,  6 Dec 2024 15:37:22 +0100
Message-ID: <20241206143531.929340573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 830d7db744b42c693bf1db7e94db86d7efd91f0e upstream.

The BINDER_WORK_FROZEN_BINDER type is not handled in the binder_logs
entries and it shows up as "unknown work" when logged:

  proc 649
  context binder-test
    thread 649: l 00 need_return 0 tr 0
    ref 13: desc 1 node 8 s 1 w 0 d 0000000053c4c0c3
    unknown work: type 10

This patch add the freeze work type and is now logged as such:

  proc 637
  context binder-test
    thread 637: l 00 need_return 0 tr 0
    ref 8: desc 1 node 3 s 1 w 0 d 00000000dc39e9c6
    has frozen binder

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-5-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6408,6 +6408,9 @@ static void print_binder_work_ilocked(st
 	case BINDER_WORK_CLEAR_DEATH_NOTIFICATION:
 		seq_printf(m, "%shas cleared death notification\n", prefix);
 		break;
+	case BINDER_WORK_FROZEN_BINDER:
+		seq_printf(m, "%shas frozen binder\n", prefix);
+		break;
 	default:
 		seq_printf(m, "%sunknown work: type %d\n", prefix, w->type);
 		break;


