Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231771F936;
	Wed, 19 Aug 2026 11:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139551; cv=none; b=aUIHz1JRBKZh1MQj9TdBJqnpBvKF8Emc+bc66HMhSme90U0xZBgbERE+iTeBlZ1tnBavYnNBdA1Pny5wqcBiu7bB91iDYzD0k+7fv5zyVDQ2dHsKpcam7td0oXK9DHimZOfa+qnvL3+KqzXfak4Qhu9l1GP4ctDnP2AyXpU7Y7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139551; c=relaxed/simple;
	bh=mGbsYURGjxEnuOgyX5qchtxIu0SQdNNbrsyp0fY+sAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAecp1rlTBjOyIZbjs7xJeCqneKXy72tw0voXQXD02Oc3wb8TeQ3qAd2L+oaPQXVY7jLCUHYGndY68IqdPKhpkW8dzvDdX61I4Xdz2iKcxEAmXucM6NeaqFuIh7Ol5eSzMWE8Wp9u7dL7oj+tJuR7UGKbUZI4MZPO8ggQNihI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVJmFcwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVJmFcwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0861F000E9;
	Wed, 19 Aug 2026 11:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787139549;
	bh=XLL+RRNRgS9R8OCQhDT7L2h5BpKzc0DSUasZrm5q0Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVJmFcwrxm7yfofPnsat31MQVVgsETza/YeBYmy14wANS6nTNpPmnIZ0s7Stfp8UU
	 GShNpPllm6BBDwgzIfRxG/hqhEgxDCeyddHyVBG6l8CptqEiY90am2gGRNuaY4Ivkv
	 kXY1Ae4Zqx3pLgdLaEW6b92kbny4DLFBcnO/DaaLDocW2VLRLqDDpIquT9oLOIdc1r
	 icSKd50DGRMadB7xr7NFGQNMeledSKon4rxajF9ZiWe0kp3vbG29ntfbj2qWiH4yf8
	 iyr9gz8PqmzttDcaKp/OPmJ564ER3et5YUHwlIR5Rrsj8caWsFbom05P4NHFqwiOGS
	 TljfCyAOjjH6Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	vegard.nossum@oracle.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 163/181] eventfs: Use children field for rcu head and add memory barriers
Date: Wed, 19 Aug 2026 07:39:05 -0400
Message-ID: <20260819113444.rc-eventfs-f0ece16f@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <24644fdf-54f1-470c-9183-8f5c420c760f@oracle.com>
References: <20260817132535.394764707@linuxfoundation.org> <20260817132542.099906154@linuxfoundation.org> <24644fdf-54f1-470c-9183-8f5c420c760f@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 01:46:51AM +0530, Harshit Mogalapalli wrote:
>The new direct return bypasses srcu_read_unlock(). This leaves the SRCU
>reader counts unbalanced and can prevent eventfs callbacks from
>completing, allowing removed inode objects to accumulate.

Confirmed, thanks. Upstream is fine because eventfs_iterate() there uses
guard(srcu)(&eventfs_srcu) after 4d9b262031ff ("eventfs: Simplify code
using guard()s"), which is only in 7.1. On 6.18, 6.12 and 6.6 the
function still does the manual srcu_read_lock() with a single out: label,
so the new "return -EINVAL" is the one post-lock path that skips
srcu_read_unlock().

>I would suggest adapting the new check to set ret = -EINVAL and goto
>out.

I'd rather not adapt the control flow by hand here, so I've dropped this
from the affected trees: 6.12, plus 6.18 and 6.6, which have the same
problem. 7.1 is correct as-is and keeps the patch.

If a properly adapted backport shows up for the older trees I'm happy to
take it.

-- 
Thanks,
Sasha
