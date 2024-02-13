Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6455A93C;
	Tue, 13 Feb 2024 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845999; cv=none; b=HZqMm/woUqaCIWgPVA9qESZtQNgHbQuv4/ectNppozD+Cn/bZPnRLeIcCeMefvhl1Et4cILCPSwGXhX+z1ckSG18+UvLmmUjRQsTpg7+K+ITL5EVDWkfSHI4FT4CZ2B5lKIeHZySYxJ38P2wCNrRAogA++Ph5RjyP5T1ciluRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845999; c=relaxed/simple;
	bh=CoYGZ3pJPCdSpVsqBmS6NuWj3y4RDqwWe1f2prYuPT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdmBSaMCX/I8eGFsvnryONPLgbDVYt9mFaMd2tThieNrNAfqj1Cx4zfKnHWmr89SZK+M71ihGnWM8ShedPAegRubqxIKoLeQ8Ofpfl1j6n9KQmxffYPN7Kx7k6p1m7Us1AAnTXhO8fiQdMAFgjKoaU1+CNIqLYLvfHpDrlg7p+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GU/mi0CK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GU/mi0CK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C766C433F1;
	Tue, 13 Feb 2024 17:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845999;
	bh=CoYGZ3pJPCdSpVsqBmS6NuWj3y4RDqwWe1f2prYuPT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU/mi0CKps/c5WtOkZhgQKNvlCo5zDfmJonwV0gc5FRCIZ8qghp7W42UpcPWwzKuG
	 Fdi4kdlTAvRvCBDkpJcgsZhAbWAK7Kv2VqgNf6Ees0MwFF5k5bufVRji0pgpSdC+Hb
	 nYJUB1xP4nFcwiIaVIKg3SQZnsb3g5nf+wgD7aUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 114/124] bcachefs: Add missing bch2_moving_ctxt_flush_all()
Date: Tue, 13 Feb 2024 18:22:16 +0100
Message-ID: <20240213171857.059984666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit ef740a1e2939376ea4cc11cc8b923214dc1f4a41 upstream.

This fixes a bug with rebalance IOs getting stuck with reads completed,
but writes never being issued.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/rebalance.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -356,6 +356,7 @@ static int do_rebalance(struct moving_co
 	    !kthread_should_stop() &&
 	    !atomic64_read(&r->work_stats.sectors_seen) &&
 	    !atomic64_read(&r->scan_stats.sectors_seen)) {
+		bch2_moving_ctxt_flush_all(ctxt);
 		bch2_trans_unlock_long(trans);
 		rebalance_wait(c);
 	}


