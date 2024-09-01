Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C231C68C;
	Sun,  1 Sep 2024 16:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209883; cv=none; b=PhFGRa429foYOTAaoJFYEYE0gyA0VWNfdBalUuuw6GT/5vLiXeA3okSrDSTV3YfYlTlzHyAGxvMED5n9JfV40uaHTYSvEBznx+n/Fooe/l3ApYcRZXk3fG7cL5wi9sqVtr3UcDU9bGGOF4UGTSJ+aLurQ04e7YSEOWheC6amHjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209883; c=relaxed/simple;
	bh=n7NPwQ6PpSCM08cGXk9NypTfHyYgPw4fNa/9RweTdYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4g8/NNJ6aQeVvi0XF4xdsTO/KDRZbmT1DfUYc3ThzwZDE6meK8pcF33DnTYkZAe1BHhuLmFbK0HUkUc+Z6iSdUQ0gcVGH7P4MbgR6r+6ePUiuofRIHd1Ahh3K48sDpxzD3h9AtKCwg8BYP2qp931gz2n7JBALy7ZUwNk4nalB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sn5OE3vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sn5OE3vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BD7C4CEC3;
	Sun,  1 Sep 2024 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209883;
	bh=n7NPwQ6PpSCM08cGXk9NypTfHyYgPw4fNa/9RweTdYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sn5OE3vsNyaRjprhxWEBU3b8r7VHFackjpiZN/lCvPBV088mRgVqr+vHc9TfRz6N6
	 M+w5CsPSpQSUtrAAFdBjvEEeqHeifhGZRXXXHZFOXkXJfC9W42+gaOG956cHgkgXnL
	 1x4GEvh7R7HnqjLlOKNUTJhDq/BMsHEREh0jetos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 022/215] memcg_write_event_control(): fix a user-triggerable oops
Date: Sun,  1 Sep 2024 18:15:34 +0200
Message-ID: <20240901160824.101030890@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 046667c4d3196938e992fba0dfcde570aa85cd0e upstream.

we are *not* guaranteed that anything past the terminating NUL
is mapped (let alone initialized with anything sane).

Fixes: 0dea116876ee ("cgroup: implement eventfd-based generic API for notifications")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4807,9 +4807,12 @@ static ssize_t memcg_write_event_control
 	buf = endp + 1;
 
 	cfd = simple_strtoul(buf, &endp, 10);
-	if ((*endp != ' ') && (*endp != '\0'))
+	if (*endp == '\0')
+		buf = endp;
+	else if (*endp == ' ')
+		buf = endp + 1;
+	else
 		return -EINVAL;
-	buf = endp + 1;
 
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)


