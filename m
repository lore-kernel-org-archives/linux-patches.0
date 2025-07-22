Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E842EA16D;
	Tue, 22 Jul 2025 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193443; cv=none; b=o3WU0U+GxVnSWJ5/RM36Xf2pMF12hBq7RCqcDnZz4/T5yFxUAyAgiDdxy3j4I79DkzhbSaHf+riTiQ9fmOwjzxMr5A6DEXhj/7bpx/3jCPxiwZqXU9sm9dbdO2LhKq3oo0h/LZMeY9t0xKHi+HjYmnUs2EUd6eOgiYNk5yWez9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193443; c=relaxed/simple;
	bh=Zn0vw1ylmebz+oFv+HgBAiRIvevp8332MJK9clsuG8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR7ND/yqoT2LfBh7SonKw5NArFX8X6ASysxY9Ie5Ok9R0vMJ2k2hXeNMLba3nQlE3lJ1ISGBmYANswDIHtaCX3wAhENktsX9qwGJfFVcVXu+8q0ipPUzTNIhZzFFnAY5P+TazYZeMBT6ULEzbf5fwL8SKww2FhoQse1Hjgltgpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yILruHOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yILruHOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6371C4CEEB;
	Tue, 22 Jul 2025 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193443;
	bh=Zn0vw1ylmebz+oFv+HgBAiRIvevp8332MJK9clsuG8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yILruHOFVUTOppWkFLYceD7g6I4QvMZiVenFzkdW7zKttBqnxkZAY2Srnku8UYp5Z
	 VUdvR4YDx5GgYTY71y1S8tbHlufRcQn1z8FgRLfd0vXlRtVM+7UW6lcVKxEM6fXhX8
	 qdGBUpV7NFyHFEkdya4ULpCiYzHjOyEsrGvpx4Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6995b62e5ac7d79557a@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.15 093/187] comedi: Fail COMEDI_INSNLIST ioctl if n_insns is too large
Date: Tue, 22 Jul 2025 15:44:23 +0200
Message-ID: <20250722134349.220965198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 08ae4b20f5e82101d77326ecab9089e110f224cc upstream.

The handling of the `COMEDI_INSNLIST` ioctl allocates a kernel buffer to
hold the array of `struct comedi_insn`, getting the length from the
`n_insns` member of the `struct comedi_insnlist` supplied by the user.
The allocation will fail with a WARNING and a stack dump if it is too
large.

Avoid that by failing with an `-EINVAL` error if the supplied `n_insns`
value is unreasonable.

Define the limit on the `n_insns` value in the `MAX_INSNS` macro.  Set
this to the same value as `MAX_SAMPLES` (65536), which is the maximum
allowed sum of the values of the member `n` in the array of `struct
comedi_insn`, and sensible comedi instructions will have an `n` of at
least 1.

Reported-by: syzbot+d6995b62e5ac7d79557a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d6995b62e5ac7d79557a
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Tested-by: Ian Abbott <abbotti@mev.co.uk>
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250704120405.83028-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -1589,6 +1589,16 @@ error:
 	return i;
 }
 
+#define MAX_INSNS   MAX_SAMPLES
+static int check_insnlist_len(struct comedi_device *dev, unsigned int n_insns)
+{
+	if (n_insns > MAX_INSNS) {
+		dev_dbg(dev->class_dev, "insnlist length too large\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * COMEDI_INSN ioctl
  * synchronous instruction
@@ -2239,6 +2249,9 @@ static long comedi_unlocked_ioctl(struct
 			rc = -EFAULT;
 			break;
 		}
+		rc = check_insnlist_len(dev, insnlist.n_insns);
+		if (rc)
+			break;
 		insns = kcalloc(insnlist.n_insns, sizeof(*insns), GFP_KERNEL);
 		if (!insns) {
 			rc = -ENOMEM;
@@ -3090,6 +3103,9 @@ static int compat_insnlist(struct file *
 	if (copy_from_user(&insnlist32, compat_ptr(arg), sizeof(insnlist32)))
 		return -EFAULT;
 
+	rc = check_insnlist_len(dev, insnlist32.n_insns);
+	if (rc)
+		return rc;
 	insns = kcalloc(insnlist32.n_insns, sizeof(*insns), GFP_KERNEL);
 	if (!insns)
 		return -ENOMEM;


