Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085981DED52;
	Mon, 18 Aug 2025 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522802; cv=none; b=JqjK/g+ztQG5SvPRUbLkpJqWsX/2egdmPpBhGWt/rHQ0zf5ktQDK/1GYxnZfi1EmPybOh/h64CsTTqKkuKClKQo3HStLtonAaDFsi11j63CWdZOI8zipJZ/Q0NXDuBzhGy+ak9OmY+8OFJVkcCYBlD4F+vZh1l8qXXI6VQ8RWdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522802; c=relaxed/simple;
	bh=wPa+cY1cZkkNjE99VaEKekqHDFbS9nWEVraVJ9PFL9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iws8BWf6B4geG/d486RqL9LDc7tmeELArtPoscEs+w8jQTIUxgyqCJ157GjkaH0pmdB7sQfcTDhL1I5NOWaChJO69+NOMUTfqcwEtKixCJ0KWKo3/0e1aJK2NwwvQARe+VP3mLGYYxvnXcmmaxR43Vh5mcGZ5q+asGMQO9KUD2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsiRo+iR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsiRo+iR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADC9C4CEEB;
	Mon, 18 Aug 2025 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522801;
	bh=wPa+cY1cZkkNjE99VaEKekqHDFbS9nWEVraVJ9PFL9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsiRo+iRt8NCpaoSfdqdg8mrZXu3RI2bp+jbR6C00lNiFb0UU34VqGMCcHPdObKwB
	 uV/yDaw3mDlxiqACdB/hk/r7M4JgjKsLMW0PTc4D44q6jdSB0y/NmvbMRoHCT39U3a
	 uCrThXGHAJWx6rH9CXRKOrk0p/t2kbid9paEkTnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naman Jain <namjain@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.12 424/444] tools/hv: fcopy: Fix irregularities with size of ring buffer
Date: Mon, 18 Aug 2025 14:47:30 +0200
Message-ID: <20250818124504.838725498@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

commit a4131a50d072b369bfed0b41e741c41fd8048641 upstream.

Size of ring buffer, as defined in uio_hv_generic driver, is no longer
fixed to 16 KB. This creates a problem in fcopy, since this size was
hardcoded. With the change in place to make ring sysfs node actually
reflect the size of underlying ring buffer, it is safe to get the size
of ring sysfs file and use it for ring buffer size in fcopy daemon.
Fix the issue of disparity in ring buffer size, by making it dynamic
in fcopy uio daemon.

Cc: stable@vger.kernel.org
Fixes: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Link: https://lore.kernel.org/r/20250711060846.9168-1-namjain@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250711060846.9168-1-namjain@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/hv/hv_fcopy_uio_daemon.c |   91 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 81 insertions(+), 10 deletions(-)

--- a/tools/hv/hv_fcopy_uio_daemon.c
+++ b/tools/hv/hv_fcopy_uio_daemon.c
@@ -35,7 +35,10 @@
 #define WIN8_SRV_MINOR		1
 #define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
 
-#define FCOPY_UIO		"/sys/bus/vmbus/devices/eb765408-105f-49b6-b4aa-c123b64d17d4/uio"
+#define FCOPY_DEVICE_PATH(subdir) \
+	"/sys/bus/vmbus/devices/eb765408-105f-49b6-b4aa-c123b64d17d4/" #subdir
+#define FCOPY_UIO_PATH          FCOPY_DEVICE_PATH(uio)
+#define FCOPY_CHANNELS_PATH     FCOPY_DEVICE_PATH(channels)
 
 #define FCOPY_VER_COUNT		1
 static const int fcopy_versions[] = {
@@ -47,9 +50,62 @@ static const int fw_versions[] = {
 	UTIL_FW_VERSION
 };
 
-#define HV_RING_SIZE		0x4000 /* 16KB ring buffer size */
+static uint32_t get_ring_buffer_size(void)
+{
+	char ring_path[PATH_MAX];
+	DIR *dir;
+	struct dirent *entry;
+	struct stat st;
+	uint32_t ring_size = 0;
+	int retry_count = 0;
 
-static unsigned char desc[HV_RING_SIZE];
+	/* Find the channel directory */
+	dir = opendir(FCOPY_CHANNELS_PATH);
+	if (!dir) {
+		usleep(100 * 1000); /* Avoid race with kernel, wait 100ms and retry once */
+		dir = opendir(FCOPY_CHANNELS_PATH);
+		if (!dir) {
+			syslog(LOG_ERR, "Failed to open channels directory: %s", strerror(errno));
+			return 0;
+		}
+	}
+
+retry_once:
+	while ((entry = readdir(dir)) != NULL) {
+		if (entry->d_type == DT_DIR && strcmp(entry->d_name, ".") != 0 &&
+		    strcmp(entry->d_name, "..") != 0) {
+			snprintf(ring_path, sizeof(ring_path), "%s/%s/ring",
+				 FCOPY_CHANNELS_PATH, entry->d_name);
+
+			if (stat(ring_path, &st) == 0) {
+				/*
+				 * stat returns size of Tx, Rx rings combined,
+				 * so take half of it for individual ring size.
+				 */
+				ring_size = (uint32_t)st.st_size / 2;
+				syslog(LOG_INFO, "Ring buffer size from %s: %u bytes",
+				       ring_path, ring_size);
+				break;
+			}
+		}
+	}
+
+	if (!ring_size && retry_count == 0) {
+		retry_count = 1;
+		rewinddir(dir);
+		usleep(100 * 1000); /* Wait 100ms and retry once */
+		goto retry_once;
+	}
+
+	closedir(dir);
+
+	if (!ring_size)
+		syslog(LOG_ERR, "Could not determine ring size");
+
+	return ring_size;
+}
+
+static unsigned char *desc;
 
 static int target_fd;
 static char target_fname[PATH_MAX];
@@ -397,7 +453,7 @@ int main(int argc, char *argv[])
 	int daemonize = 1, long_index = 0, opt, ret = -EINVAL;
 	struct vmbus_br txbr, rxbr;
 	void *ring;
-	uint32_t len = HV_RING_SIZE;
+	uint32_t ring_size, len;
 	char uio_name[NAME_MAX] = {0};
 	char uio_dev_path[PATH_MAX] = {0};
 
@@ -428,7 +484,20 @@ int main(int argc, char *argv[])
 	openlog("HV_UIO_FCOPY", 0, LOG_USER);
 	syslog(LOG_INFO, "starting; pid is:%d", getpid());
 
-	fcopy_get_first_folder(FCOPY_UIO, uio_name);
+	ring_size = get_ring_buffer_size();
+	if (!ring_size) {
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	desc = malloc(ring_size * sizeof(unsigned char));
+	if (!desc) {
+		syslog(LOG_ERR, "malloc failed for desc buffer");
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	fcopy_get_first_folder(FCOPY_UIO_PATH, uio_name);
 	snprintf(uio_dev_path, sizeof(uio_dev_path), "/dev/%s", uio_name);
 	fcopy_fd = open(uio_dev_path, O_RDWR);
 
@@ -436,17 +505,17 @@ int main(int argc, char *argv[])
 		syslog(LOG_ERR, "open %s failed; error: %d %s",
 		       uio_dev_path, errno, strerror(errno));
 		ret = fcopy_fd;
-		goto exit;
+		goto free_desc;
 	}
 
-	ring = vmbus_uio_map(&fcopy_fd, HV_RING_SIZE);
+	ring = vmbus_uio_map(&fcopy_fd, ring_size);
 	if (!ring) {
 		ret = errno;
 		syslog(LOG_ERR, "mmap ringbuffer failed; error: %d %s", ret, strerror(ret));
 		goto close;
 	}
-	vmbus_br_setup(&txbr, ring, HV_RING_SIZE);
-	vmbus_br_setup(&rxbr, (char *)ring + HV_RING_SIZE, HV_RING_SIZE);
+	vmbus_br_setup(&txbr, ring, ring_size);
+	vmbus_br_setup(&rxbr, (char *)ring + ring_size, ring_size);
 
 	rxbr.vbr->imask = 0;
 
@@ -461,7 +530,7 @@ int main(int argc, char *argv[])
 			continue;
 		}
 
-		len = HV_RING_SIZE;
+		len = ring_size;
 		ret = rte_vmbus_chan_recv_raw(&rxbr, desc, &len);
 		if (unlikely(ret <= 0)) {
 			/* This indicates a failure to communicate (or worse) */
@@ -481,6 +550,8 @@ int main(int argc, char *argv[])
 	}
 close:
 	close(fcopy_fd);
+free_desc:
+	free(desc);
 exit:
 	return ret;
 }


