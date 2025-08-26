Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B579C2AD04;
	Tue, 26 Aug 2025 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215519; cv=none; b=USlPAPQj0RCCzrf8ariBb9n5cCetsXcnvp9SHGYrJQ50eCiVhtnI5VrmWh9QJCqzWKvLJX9Far9tYwoxgQ29lP1WlWHHQ+B3RR5ib5AywrOktnP2iDedibbf7Xt5mkrAL3BkWrfHYshG9xnvJWYFHXTAQfx+ikCyCqTCVwO8HjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215519; c=relaxed/simple;
	bh=gZU2R+nITtyhvRh7jPNSHD26e3JnGwLtrzm1Fx8CrGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqMin5xMXeYRXiAxUnLum3mbqZpDzF4ZSGWqLm9QbQ+e15rwNoXZwe2azXK30ItzsT9KTGsDEuCa/CRcVNZ2j5jgsMDmBSPMYxUqcFSndA9DH+Tk7BPuGH7JqWWeAIOlv+EtExS9/9fYX3t/g2C3/7yvQgemp8N+botPQSGDF6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDsSXCLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDsSXCLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8C6C4CEF1;
	Tue, 26 Aug 2025 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215519;
	bh=gZU2R+nITtyhvRh7jPNSHD26e3JnGwLtrzm1Fx8CrGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDsSXCLtjapcL48U2ozqbXHeSFWsZh70/BFiS9FOSvPL2VTRZz8RqmZoIGfMb9UCg
	 3gXAwIctrOIuVofTXxn5gC6h4i+M/mNTnM/oiX6UYRxoootbN8amDUWJirKYLw94Sn
	 8ApAyrR2GgDwiTUotQfPooUBbP3nS7bgAVpmdwRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d6995b62e5ac7d79557a@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 033/644] comedi: Fail COMEDI_INSNLIST ioctl if n_insns is too large
Date: Tue, 26 Aug 2025 13:02:04 +0200
Message-ID: <20250826110947.331272991@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1584,6 +1584,16 @@ error:
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
@@ -2234,6 +2244,9 @@ static long comedi_unlocked_ioctl(struct
 			rc = -EFAULT;
 			break;
 		}
+		rc = check_insnlist_len(dev, insnlist.n_insns);
+		if (rc)
+			break;
 		insns = kcalloc(insnlist.n_insns, sizeof(*insns), GFP_KERNEL);
 		if (!insns) {
 			rc = -ENOMEM;
@@ -3085,6 +3098,9 @@ static int compat_insnlist(struct file *
 	if (copy_from_user(&insnlist32, compat_ptr(arg), sizeof(insnlist32)))
 		return -EFAULT;
 
+	rc = check_insnlist_len(dev, insnlist32.n_insns);
+	if (rc)
+		return rc;
 	insns = kcalloc(insnlist32.n_insns, sizeof(*insns), GFP_KERNEL);
 	if (!insns)
 		return -ENOMEM;


