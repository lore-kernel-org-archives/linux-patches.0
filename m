Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11C42C6AF;
	Sun,  1 Sep 2024 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210407; cv=none; b=vB4pcBNwhMEWlOHjEEBuxYy2VdOnJG8UiL+/J8eVQxUnwGMvVEaBKUR+xkoM7XZc8lyPwGZ/Byn8suxk78iZTxReq06UVGxR4+15OiQ73U8qQOHVsxgo6nsm5MtyrYQfARFeTzf8enS+t5dug0n2me9IpeOBjTp8E8ZlH3wB9cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210407; c=relaxed/simple;
	bh=suM+LlxoHUt6e+/rIHw5BTtbDxPdQvP3K0FXMNUzwzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUsUvKI5xtHIKP+qLkdJTCQrolmmOuZyDASsMfc27TOQt4J7u4smRz6mrn4w8yfzTVhOAVT5BkZ+XpYujK335fUgi1bW9BAZ8XkWz8kyPkIMa5yuPHV+WvLNtdDsg5irKGjjwKS0NZIGfLe793FM4TU+NyR2IrI9AmJ6vaeqH1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyxuN45A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyxuN45A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A784C4CEC3;
	Sun,  1 Sep 2024 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210407;
	bh=suM+LlxoHUt6e+/rIHw5BTtbDxPdQvP3K0FXMNUzwzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyxuN45AqiFtVGbnIQ1ELcNLl95RXHQkKDf/DJZFqYQWceiuPT54gC7yvP/w+ZUBT
	 Z9whK9M/Kbwec/nyrIoh9QpTWptMZHGswbiQz8w/VGdZX1f9C1sa1VF+UMHBH0HrK9
	 2YXbjrijbeOL4fmthn91ZClgS3vGHrwJxpROLEII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 181/215] mptcp: sched: check both backup in retrans
Date: Sun,  1 Sep 2024 18:18:13 +0200
Message-ID: <20240901160830.202376258@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 2a1f596ebb23eadc0f9b95a8012e18ef76295fc8 upstream.

The 'mptcp_subflow_context' structure has two items related to the
backup flags:

 - 'backup': the subflow has been marked as backup by the other peer

 - 'request_bkup': the backup flag has been set by the host

Looking only at the 'backup' flag can make sense in some cases, but it
is not the behaviour of the default packet scheduler when selecting
paths.

As explained in the commit b6a66e521a20 ("mptcp: sched: check both
directions for backup"), the packet scheduler should look at both flags,
because that was the behaviour from the beginning: the 'backup' flag was
set by accident instead of the 'request_bkup' one. Now that the latter
has been fixed, get_retrans() needs to be adapted as well.

Fixes: b6a66e521a20 ("mptcp: sched: check both directions for backup")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240826-net-mptcp-close-extra-sf-fin-v1-3-905199fe1172@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2213,7 +2213,7 @@ static struct sock *mptcp_subflow_get_re
 			continue;
 		}
 
-		if (subflow->backup) {
+		if (subflow->backup || subflow->request_bkup) {
 			if (!backup)
 				backup = ssk;
 			continue;


