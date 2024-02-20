Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22914612D7;
	Tue, 20 Feb 2024 21:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463527; cv=none; b=QV4AP6ZAyRt20XwA1EWWmTEWWbwzfxX8ZehU7dW1zUwxWEGoKhq+H/mCqSovkPXi0nMzNVrGFWM3lGbyg3SKspymDlQ8bYyGPj1YMokCq8R6qBro+5HSdk+jc+2gdvYNsS3e5HH01UIZrtP0PQkjJVnsLf+LrIVFjkY6vm+xJOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463527; c=relaxed/simple;
	bh=1afAshXzfk8i06HsxgNgobn8szX0ktqQnWF+30YXUGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9pD7Jl4WHB33P+580wwKfXHi29hqICF+ZQuyC9kvfJ3dASOh4jEk6Z26x/Alo6+aDOpqDLLEHPpXJNI6htdc6MeBp28KhUZk9/R1jOcTwN3avtjYchSzDe/zH/Pw5gUnjszj7HN9rv3kz/ZIRo+MukyNGWV7SroeBrUrS5jCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRLhkc3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRLhkc3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B106C433C7;
	Tue, 20 Feb 2024 21:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463526;
	bh=1afAshXzfk8i06HsxgNgobn8szX0ktqQnWF+30YXUGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRLhkc3WdkSLVnntD8AdqttJAz6t63DnM+7NL1lK0ygTbhQyPlrnRg9RXR9efoNCU
	 GR1Fea0ckW5V9hDw/ldSzrfUKxS370mLJwRxD0RnrOMUOnYcnyVR9i0r0yYQ9NGjzv
	 AU90zr/ScsMfDWeLhluQT+ETPytB+8jtRwYPRzOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 071/331] HID: bpf: remove double fdget()
Date: Tue, 20 Feb 2024 21:53:07 +0100
Message-ID: <20240220205639.804501464@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 7cdd2108903a4e369eb37579830afc12a6877ec2 upstream.

When the kfunc hid_bpf_attach_prog() is called, we called twice fdget():
one for fetching the type of the bpf program, and one for actually
attaching the program to the device.

The problem is that between those two calls, we have no guarantees that
the prog_fd is still the same file descriptor for the given program.

Solve this by calling bpf_prog_get() earlier, and use this to fetch the
program type.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/bpf/CAO-hwJJ8vh8JD3-P43L-_CLNmPx0hWj44aom0O838vfP4=_1CA@mail.gmail.com/T/#t
Cc: <stable@vger.kernel.org>
Fixes: f5c27da4e3c8 ("HID: initial BPF implementation")
Link: https://lore.kernel.org/r/20240124-b4-hid-bpf-fixes-v2-1-052520b1e5e6@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c  |   66 ++++++++++++++++++++++++------------
 drivers/hid/bpf/hid_bpf_dispatch.h  |    4 +-
 drivers/hid/bpf/hid_bpf_jmp_table.c |   20 +---------
 3 files changed, 49 insertions(+), 41 deletions(-)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -241,6 +241,39 @@ int hid_bpf_reconnect(struct hid_device
 	return 0;
 }
 
+static int do_hid_bpf_attach_prog(struct hid_device *hdev, int prog_fd, struct bpf_prog *prog,
+				  __u32 flags)
+{
+	int fd, err, prog_type;
+
+	prog_type = hid_bpf_get_prog_attach_type(prog);
+	if (prog_type < 0)
+		return prog_type;
+
+	if (prog_type >= HID_BPF_PROG_TYPE_MAX)
+		return -EINVAL;
+
+	if (prog_type == HID_BPF_PROG_TYPE_DEVICE_EVENT) {
+		err = hid_bpf_allocate_event_data(hdev);
+		if (err)
+			return err;
+	}
+
+	fd = __hid_bpf_attach_prog(hdev, prog_type, prog_fd, prog, flags);
+	if (fd < 0)
+		return fd;
+
+	if (prog_type == HID_BPF_PROG_TYPE_RDESC_FIXUP) {
+		err = hid_bpf_reconnect(hdev);
+		if (err) {
+			close_fd(fd);
+			return err;
+		}
+	}
+
+	return fd;
+}
+
 /**
  * hid_bpf_attach_prog - Attach the given @prog_fd to the given HID device
  *
@@ -257,18 +290,13 @@ noinline int
 hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags)
 {
 	struct hid_device *hdev;
+	struct bpf_prog *prog;
 	struct device *dev;
-	int fd, err, prog_type = hid_bpf_get_prog_attach_type(prog_fd);
+	int fd;
 
 	if (!hid_bpf_ops)
 		return -EINVAL;
 
-	if (prog_type < 0)
-		return prog_type;
-
-	if (prog_type >= HID_BPF_PROG_TYPE_MAX)
-		return -EINVAL;
-
 	if ((flags & ~HID_BPF_FLAG_MASK))
 		return -EINVAL;
 
@@ -278,23 +306,17 @@ hid_bpf_attach_prog(unsigned int hid_id,
 
 	hdev = to_hid_device(dev);
 
-	if (prog_type == HID_BPF_PROG_TYPE_DEVICE_EVENT) {
-		err = hid_bpf_allocate_event_data(hdev);
-		if (err)
-			return err;
-	}
+	/*
+	 * take a ref on the prog itself, it will be released
+	 * on errors or when it'll be detached
+	 */
+	prog = bpf_prog_get(prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
 
-	fd = __hid_bpf_attach_prog(hdev, prog_type, prog_fd, flags);
+	fd = do_hid_bpf_attach_prog(hdev, prog_fd, prog, flags);
 	if (fd < 0)
-		return fd;
-
-	if (prog_type == HID_BPF_PROG_TYPE_RDESC_FIXUP) {
-		err = hid_bpf_reconnect(hdev);
-		if (err) {
-			close_fd(fd);
-			return err;
-		}
-	}
+		bpf_prog_put(prog);
 
 	return fd;
 }
--- a/drivers/hid/bpf/hid_bpf_dispatch.h
+++ b/drivers/hid/bpf/hid_bpf_dispatch.h
@@ -12,9 +12,9 @@ struct hid_bpf_ctx_kern {
 
 int hid_bpf_preload_skel(void);
 void hid_bpf_free_links_and_skel(void);
-int hid_bpf_get_prog_attach_type(int prog_fd);
+int hid_bpf_get_prog_attach_type(struct bpf_prog *prog);
 int __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type, int prog_fd,
-			  __u32 flags);
+			  struct bpf_prog *prog, __u32 flags);
 void __hid_bpf_destroy_device(struct hid_device *hdev);
 int hid_bpf_prog_run(struct hid_device *hdev, enum hid_bpf_prog_type type,
 		     struct hid_bpf_ctx_kern *ctx_kern);
--- a/drivers/hid/bpf/hid_bpf_jmp_table.c
+++ b/drivers/hid/bpf/hid_bpf_jmp_table.c
@@ -333,15 +333,10 @@ static int hid_bpf_insert_prog(int prog_
 	return err;
 }
 
-int hid_bpf_get_prog_attach_type(int prog_fd)
+int hid_bpf_get_prog_attach_type(struct bpf_prog *prog)
 {
-	struct bpf_prog *prog = NULL;
-	int i;
 	int prog_type = HID_BPF_PROG_TYPE_UNDEF;
-
-	prog = bpf_prog_get(prog_fd);
-	if (IS_ERR(prog))
-		return PTR_ERR(prog);
+	int i;
 
 	for (i = 0; i < HID_BPF_PROG_TYPE_MAX; i++) {
 		if (hid_bpf_btf_ids[i] == prog->aux->attach_btf_id) {
@@ -350,8 +345,6 @@ int hid_bpf_get_prog_attach_type(int pro
 		}
 	}
 
-	bpf_prog_put(prog);
-
 	return prog_type;
 }
 
@@ -388,19 +381,13 @@ static const struct bpf_link_ops hid_bpf
 /* called from syscall */
 noinline int
 __hid_bpf_attach_prog(struct hid_device *hdev, enum hid_bpf_prog_type prog_type,
-		      int prog_fd, __u32 flags)
+		      int prog_fd, struct bpf_prog *prog, __u32 flags)
 {
 	struct bpf_link_primer link_primer;
 	struct hid_bpf_link *link;
-	struct bpf_prog *prog = NULL;
 	struct hid_bpf_prog_entry *prog_entry;
 	int cnt, err = -EINVAL, prog_table_idx = -1;
 
-	/* take a ref on the prog itself */
-	prog = bpf_prog_get(prog_fd);
-	if (IS_ERR(prog))
-		return PTR_ERR(prog);
-
 	mutex_lock(&hid_bpf_attach_lock);
 
 	link = kzalloc(sizeof(*link), GFP_USER);
@@ -467,7 +454,6 @@ __hid_bpf_attach_prog(struct hid_device
  err_unlock:
 	mutex_unlock(&hid_bpf_attach_lock);
 
-	bpf_prog_put(prog);
 	kfree(link);
 
 	return err;


