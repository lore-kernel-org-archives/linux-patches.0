Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AAA193;
	Fri,  6 Dec 2024 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496336; cv=none; b=hUea3HLb93A+1iUOE4uvct6XKxR4pZFTAPDQBj4GBl+gBbDOvHqAUorQaxwhWI6uZfnWFaNSZeqmbsCA8wqwFGs4uPXdZaQo6hCHD7TMI98/umeu4dP83Pu3+Z0CYqh9JIPHQTqsd9DsxYSpbLJlEVXNq51sitFbPjXmJD7YwUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496336; c=relaxed/simple;
	bh=cFBZeuIk+ic6Ql0cR+SCLfqOi/1IE2km0oKIGvQwJUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hhoi59sx5bEeoc6h1+Fx3JUyPwhdnOg0kIAPrHVrKEanZYn8wdRNl7li78UtJitnp+LyqV7WWafSxeSvk6j+BE0eHq2vgM1vYOljCAaAAvTqrTOnxO0r5e+5Twt7j6KF0MA1eiWECN6YjXnk0pnbdbAVggxGFOrk/Mv2gaSY7/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+o5gr8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+o5gr8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21800C4CED1;
	Fri,  6 Dec 2024 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496336;
	bh=cFBZeuIk+ic6Ql0cR+SCLfqOi/1IE2km0oKIGvQwJUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+o5gr8W5j8AspDLuSH7p3e2lhROQkiRcEXzKgB5Ijs9frSP5jNH6yQdBN38A8Ie/
	 rT1qSh4JUtfzA5sl+gvD7gYs96Gc0oEX0NDxrdm3/ptCtU8nChLsh/r3TfT2gxxfuF
	 fYj+0d0XLhUunllgAUitT+aamwFeoeicIRi7SGZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12 115/146] binder: add delivered_freeze to debugfs output
Date: Fri,  6 Dec 2024 15:37:26 +0100
Message-ID: <20241206143532.081095707@linuxfoundation.org>
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

commit cb2aeb2ec25884133110ffe5a67ff3cf7dee5ceb upstream.

Add the pending proc->delivered_freeze work to the debugfs output. This
information was omitted in the original implementation of the freeze
notification and can be valuable for debugging issues.

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-9-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 7c09b5e38e32..ef353ca13c35 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6569,6 +6569,10 @@ static void print_binder_proc(struct seq_file *m,
 		seq_puts(m, "  has delivered dead binder\n");
 		break;
 	}
+	list_for_each_entry(w, &proc->delivered_freeze, entry) {
+		seq_puts(m, "  has delivered freeze binder\n");
+		break;
+	}
 	binder_inner_proc_unlock(proc);
 	if (!print_all && m->count == header_pos)
 		m->count = start_pos;
-- 
2.47.1



