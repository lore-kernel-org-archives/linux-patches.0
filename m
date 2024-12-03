Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA2F1F76DB;
	Tue,  3 Dec 2024 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242302; cv=none; b=pumIeC+W7ltT72ihvw5arRhwcOqJGj21dWGnrkwFvmKM++X6WWkkKfIxL4uamC1R4kUvBnu2lRFZAiXCOpJhTwvRlLzyz6gYOQKX5xgGEMh9IRQbL740mrid3YWa2DtOa52G1FZn2qc5XqwP1NwmuKk9Go41Sgkk1GGS308981M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242302; c=relaxed/simple;
	bh=2xVGwk94yOV04Ij8NTRxV5HR98pTQJ08/WD9xWMt5uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/wNyQXh5k4NwaoEjqq+vIzJSXEEjEzVKmtlCVOhsr65cqzA3xiyDEGuvIs9s85qOOIZCKHK3wdPOrqMFFpvnEw0Lmf85idPY5HFYxGNp7bX3hP3hifQO400PSgn1cDWb0EqKgmuzIEsbibB8t/sY898xC29EAAxcZNmw96iLTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dO5XSGt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dO5XSGt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBACFC4CECF;
	Tue,  3 Dec 2024 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242302;
	bh=2xVGwk94yOV04Ij8NTRxV5HR98pTQJ08/WD9xWMt5uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dO5XSGt9Wph6aAKrySwzUEpXg3E/eP9X/No3HVWOK4/ewbaKeXhvFM2gY2JGGPBIw
	 cVfnH2PtZJGJ4ocX9fYlQudr1DKQ36TCan3nWM8hZi6LOsE4yOJ5xtHnrRxrQKSQbK
	 Sq0jb+PDfWf4QnEYADZxjX2LUd2NUUAfygNPWq+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 666/826] fcntl: make F_DUPFD_QUERY associative
Date: Tue,  3 Dec 2024 15:46:33 +0100
Message-ID: <20241203144809.734838096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 2714b0d1f36999dbd99a3474a24e7301acbd74f1 upstream.

Currently when passing a closed file descriptor to
fcntl(fd, F_DUPFD_QUERY, fd_dup) the order matters:

    fd = open("/dev/null");
    fd_dup = dup(fd);

When we now close one of the file descriptors we get:

    (1) fcntl(fd, fd_dup) // -EBADF
    (2) fcntl(fd_dup, fd) // 0 aka not equal

depending on which file descriptor is passed first. That's not a huge
deal but it gives the api I slightly weird feel. Make it so that the
order doesn't matter by requiring that both file descriptors are valid:

(1') fcntl(fd, fd_dup) // -EBADF
(2') fcntl(fd_dup, fd) // -EBADF

Link: https://lore.kernel.org/r/20241008-duften-formel-251f967602d5@brauner
Fixes: c62b758bae6a ("fcntl: add F_DUPFD_QUERY fcntl()")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-By: Lennart Poettering <lennart@poettering.net>
Cc: stable@vger.kernel.org
Reported-by: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fcntl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -397,6 +397,9 @@ static long f_dupfd_query(int fd, struct
 {
 	CLASS(fd_raw, f)(fd);
 
+	if (fd_empty(f))
+		return -EBADF;
+
 	/*
 	 * We can do the 'fdput()' immediately, as the only thing that
 	 * matters is the pointer value which isn't changed by the fdput.


