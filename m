Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B45B3C140F;
	Wed, 20 May 2026 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300779; cv=none; b=iwv/L17/t6M51dtHvDlK4Rmw9SDqR17tcO/iJWcJnwbX03M8z/wTgf/O5wCzS7LvqwbiiescIjKCtEvOJAnr6TevaKokibDDScqWNciN4f2YiiG83XmdaaMTbzs6dx6bxbhUzQpGs5+yczW1dapEp+GOssft+M+1v4v/qldmigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300779; c=relaxed/simple;
	bh=+KlSN3n7FkrNWTN/OP4lomsTKyz1XItzOk/vYoySQLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlkcCOY+xSWr2gAxJPlE8zmwpdPfSeWH6hNJYSDK8fhu5dM9HVwDKKdSivBU77uTy2/GOlGjK7xR5+cKvayZ0CMq6qf2VEVh5AtFGOSwrIT34erqMr7pjXiuOnjzh4L6peRRIIJHNrLEgYI2aY3gRpGc4H2jzlN2mfe0QlKlPHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwOOZs+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwOOZs+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C0E1F000E9;
	Wed, 20 May 2026 18:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300777;
	bh=HIpCEJTJEl/damb4W2sRlBB4svHeBCiRDL6scC9ONYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwOOZs+gI/fg7uOgRRIqEA18TDtLEz4qruv+Qs+dUtKZCc1tgns0tyijk++3PZP3a
	 M7YFPVX8b4EkBhijjq3NzA6UJkBVxyQ2bUB8IQXGIX5JDkLl4qmbK9szc39bTYkNFz
	 5MT7CJjs604wQ3fw41Nehbwb3riEO8c5+iJODhwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/666] net/socket.c: switch to CLASS(fd)
Date: Wed, 20 May 2026 18:17:43 +0200
Message-ID: <20260520162116.678372765@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 53c0a58beb60b76e105a61aae518fd780eec03d9 ]

	The important part in sockfd_lookup_light() is avoiding needless
file refcount operations, not the marginal reduction of the register
pressure from not keeping a struct file pointer in the caller.

	Switch to use fdget()/fdpu(); with sane use of CLASS(fd) we can
get a better code generation...

	Would be nice if somebody tested it on networking test suites
(including benchmarks)...

	sockfd_lookup_light() does fdget(), uses sock_from_file() to
get the associated socket and returns the struct socket reference to
the caller, along with "do we need to fput()" flag.  No matching fdput(),
the caller does its equivalent manually, using the fact that sock->file
points to the struct file the socket has come from.

	Get rid of that - have the callers do fdget()/fdput() and
use sock_from_file() directly.  That kills sockfd_lookup_light()
and fput_light() (no users left).

	What's more, we can get rid of explicit fdget()/fdput() by
switching to CLASS(fd, ...) - code generation does not suffer, since
now fdput() inserted on "descriptor is not opened" failure exit
is recognized to be a no-op by compiler.

[folded a fix for braino in do_recvmmsg() caught by Simon Horman]

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 66052a768d47 ("fanotify: call fanotify_events_supported() before path_permission() and security_path_notify()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/file.h |   6 -
 net/socket.c         | 303 +++++++++++++++++++------------------------
 2 files changed, 137 insertions(+), 172 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index f98de143245ab..b49a92295b3ff 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -30,12 +30,6 @@ extern struct file *alloc_file_pseudo_noaccount(struct inode *, struct vfsmount
 extern struct file *alloc_file_clone(struct file *, int flags,
 	const struct file_operations *);
 
-static inline void fput_light(struct file *file, int fput_needed)
-{
-	if (fput_needed)
-		fput(file);
-}
-
 /* either a reference to struct file + flags
  * (cloned vs. borrowed, pos locked), with
  * flags stored in lower bits of value,
diff --git a/net/socket.c b/net/socket.c
index a0f6f8b3376d5..878155076bc0f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -509,7 +509,7 @@ static int sock_map_fd(struct socket *sock, int flags)
 
 struct socket *sock_from_file(struct file *file)
 {
-	if (file->f_op == &socket_file_ops)
+	if (likely(file->f_op == &socket_file_ops))
 		return file->private_data;	/* set in sock_alloc_file */
 
 	return NULL;
@@ -549,24 +549,6 @@ struct socket *sockfd_lookup(int fd, int *err)
 }
 EXPORT_SYMBOL(sockfd_lookup);
 
-static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
-{
-	struct fd f = fdget(fd);
-	struct socket *sock;
-
-	*err = -EBADF;
-	if (fd_file(f)) {
-		sock = sock_from_file(fd_file(f));
-		if (likely(sock)) {
-			*fput_needed = f.word & FDPUT_FPUT;
-			return sock;
-		}
-		*err = -ENOTSOCK;
-		fdput(f);
-	}
-	return NULL;
-}
-
 static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 				size_t size)
 {
@@ -1857,16 +1839,20 @@ int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
-
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock) {
-		err = move_addr_to_kernel(umyaddr, addrlen, &address);
-		if (!err)
-			err = __sys_bind_socket(sock, &address, addrlen);
-		fput_light(sock->file, fput_needed);
-	}
-	return err;
+	CLASS(fd, f)(fd);
+	int err;
+
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	err = move_addr_to_kernel(umyaddr, addrlen, &address);
+	if (unlikely(err))
+		return err;
+
+	return __sys_bind_socket(sock, &address, addrlen);
 }
 
 SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
@@ -1895,15 +1881,16 @@ int __sys_listen_socket(struct socket *sock, int backlog)
 
 int __sys_listen(int fd, int backlog)
 {
+	CLASS(fd, f)(fd);
 	struct socket *sock;
-	int err, fput_needed;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock) {
-		err = __sys_listen_socket(sock, backlog);
-		fput_light(sock->file, fput_needed);
-	}
-	return err;
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	return __sys_listen_socket(sock, backlog);
 }
 
 SYSCALL_DEFINE2(listen, int, fd, int, backlog)
@@ -2013,17 +2000,12 @@ static int __sys_accept4_file(struct file *file, struct sockaddr __user *upeer_s
 int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 		  int __user *upeer_addrlen, int flags)
 {
-	int ret = -EBADF;
-	struct fd f;
+	CLASS(fd, f)(fd);
 
-	f = fdget(fd);
-	if (fd_file(f)) {
-		ret = __sys_accept4_file(fd_file(f), upeer_sockaddr,
+	if (fd_empty(f))
+		return -EBADF;
+	return __sys_accept4_file(fd_file(f), upeer_sockaddr,
 					 upeer_addrlen, flags);
-		fdput(f);
-	}
-
-	return ret;
 }
 
 SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
@@ -2075,20 +2057,18 @@ int __sys_connect_file(struct file *file, struct sockaddr_storage *address,
 
 int __sys_connect(int fd, struct sockaddr __user *uservaddr, int addrlen)
 {
-	int ret = -EBADF;
-	struct fd f;
+	struct sockaddr_storage address;
+	CLASS(fd, f)(fd);
+	int ret;
 
-	f = fdget(fd);
-	if (fd_file(f)) {
-		struct sockaddr_storage address;
+	if (fd_empty(f))
+		return -EBADF;
 
-		ret = move_addr_to_kernel(uservaddr, addrlen, &address);
-		if (!ret)
-			ret = __sys_connect_file(fd_file(f), &address, addrlen, 0);
-		fdput(f);
-	}
+	ret = move_addr_to_kernel(uservaddr, addrlen, &address);
+	if (ret)
+		return ret;
 
-	return ret;
+	return __sys_connect_file(fd_file(f), &address, addrlen, 0);
 }
 
 SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
@@ -2107,26 +2087,25 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
+	CLASS(fd, f)(fd);
+	int err;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		goto out;
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
 	err = security_socket_getsockname(sock);
 	if (err)
-		goto out_put;
+		return err;
 
 	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, 0);
 	if (err < 0)
-		goto out_put;
-	/* "err" is actually length in this case */
-	err = move_addr_to_user(&address, err, usockaddr, usockaddr_len);
+		return err;
 
-out_put:
-	fput_light(sock->file, fput_needed);
-out:
-	return err;
+	/* "err" is actually length in this case */
+	return move_addr_to_user(&address, err, usockaddr, usockaddr_len);
 }
 
 SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
@@ -2145,26 +2124,25 @@ int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
+	CLASS(fd, f)(fd);
+	int err;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock != NULL) {
-		const struct proto_ops *ops = READ_ONCE(sock->ops);
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
-		err = security_socket_getpeername(sock);
-		if (err) {
-			fput_light(sock->file, fput_needed);
-			return err;
-		}
+	err = security_socket_getpeername(sock);
+	if (err)
+		return err;
 
-		err = ops->getname(sock, (struct sockaddr *)&address, 1);
-		if (err >= 0)
-			/* "err" is actually length in this case */
-			err = move_addr_to_user(&address, err, usockaddr,
-						usockaddr_len);
-		fput_light(sock->file, fput_needed);
-	}
-	return err;
+	err = READ_ONCE(sock->ops)->getname(sock, (struct sockaddr *)&address, 1);
+	if (err < 0)
+		return err;
+
+	/* "err" is actually length in this case */
+	return move_addr_to_user(&address, err, usockaddr, usockaddr_len);
 }
 
 SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr __user *, usockaddr,
@@ -2185,14 +2163,17 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	struct sockaddr_storage address;
 	int err;
 	struct msghdr msg;
-	int fput_needed;
 
 	err = import_ubuf(ITER_SOURCE, buff, len, &msg.msg_iter);
 	if (unlikely(err))
 		return err;
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		goto out;
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
@@ -2202,7 +2183,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	if (addr) {
 		err = move_addr_to_kernel(addr, addr_len, &address);
 		if (err < 0)
-			goto out_put;
+			return err;
 		msg.msg_name = (struct sockaddr *)&address;
 		msg.msg_namelen = addr_len;
 	}
@@ -2210,12 +2191,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	msg.msg_flags = flags;
-	err = __sock_sendmsg(sock, &msg);
-
-out_put:
-	fput_light(sock->file, fput_needed);
-out:
-	return err;
+	return __sock_sendmsg(sock, &msg);
 }
 
 SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
@@ -2250,14 +2226,18 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	};
 	struct socket *sock;
 	int err, err2;
-	int fput_needed;
 
 	err = import_ubuf(ITER_DEST, ubuf, size, &msg.msg_iter);
 	if (unlikely(err))
 		return err;
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		goto out;
+
+	CLASS(fd, f)(fd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -2269,9 +2249,6 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 		if (err2 < 0)
 			err = err2;
 	}
-
-	fput_light(sock->file, fput_needed);
-out:
 	return err;
 }
 
@@ -2346,17 +2323,16 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 {
 	sockptr_t optval = USER_SOCKPTR(user_optval);
 	bool compat = in_compat_syscall();
-	int err, fput_needed;
 	struct socket *sock;
+	CLASS(fd, f)(fd);
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
-
-	err = do_sock_setsockopt(sock, compat, level, optname, optval, optlen);
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
-	fput_light(sock->file, fput_needed);
-	return err;
+	return do_sock_setsockopt(sock, compat, level, optname, optval, optlen);
 }
 
 SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
@@ -2412,20 +2388,17 @@ EXPORT_SYMBOL(do_sock_getsockopt);
 int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		int __user *optlen)
 {
-	int err, fput_needed;
 	struct socket *sock;
-	bool compat;
+	CLASS(fd, f)(fd);
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
-	compat = in_compat_syscall();
-	err = do_sock_getsockopt(sock, compat, level, optname,
+	return do_sock_getsockopt(sock, in_compat_syscall(), level, optname,
 				 USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
-
-	fput_light(sock->file, fput_needed);
-	return err;
 }
 
 SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
@@ -2451,15 +2424,16 @@ int __sys_shutdown_sock(struct socket *sock, int how)
 
 int __sys_shutdown(int fd, int how)
 {
-	int err, fput_needed;
 	struct socket *sock;
+	CLASS(fd, f)(fd);
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock != NULL) {
-		err = __sys_shutdown_sock(sock, how);
-		fput_light(sock->file, fput_needed);
-	}
-	return err;
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	return __sys_shutdown_sock(sock, how);
 }
 
 SYSCALL_DEFINE2(shutdown, int, fd, int, how)
@@ -2675,22 +2649,21 @@ long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
 		   bool forbid_cmsg_compat)
 {
-	int fput_needed, err;
 	struct msghdr msg_sys;
 	struct socket *sock;
 
 	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		goto out;
+	CLASS(fd, f)(fd);
 
-	err = ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL, 0);
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
-	fput_light(sock->file, fput_needed);
-out:
-	return err;
+	return ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL, 0);
 }
 
 SYSCALL_DEFINE3(sendmsg, int, fd, struct user_msghdr __user *, msg, unsigned int, flags)
@@ -2705,7 +2678,7 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct user_msghdr __user *, msg, unsigned int
 int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		   unsigned int flags, bool forbid_cmsg_compat)
 {
-	int fput_needed, err, datagrams;
+	int err, datagrams;
 	struct socket *sock;
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
@@ -2721,9 +2694,13 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	datagrams = 0;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
+	CLASS(fd, f)(fd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
 	used_address.name_len = UINT_MAX;
 	entry = mmsg;
@@ -2760,8 +2737,6 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		cond_resched();
 	}
 
-	fput_light(sock->file, fput_needed);
-
 	/* We only return an error if no datagrams were able to be sent */
 	if (datagrams != 0)
 		return datagrams;
@@ -2883,22 +2858,21 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
 		   bool forbid_cmsg_compat)
 {
-	int fput_needed, err;
 	struct msghdr msg_sys;
 	struct socket *sock;
 
 	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		goto out;
+	CLASS(fd, f)(fd);
 
-	err = ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
-	fput_light(sock->file, fput_needed);
-out:
-	return err;
+	return ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
 }
 
 SYSCALL_DEFINE3(recvmsg, int, fd, struct user_msghdr __user *, msg,
@@ -2915,7 +2889,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  struct timespec64 *timeout)
 {
-	int fput_needed, err, datagrams;
+	int err = 0, datagrams;
 	struct socket *sock;
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
@@ -2930,16 +2904,18 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 
 	datagrams = 0;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
+	CLASS(fd, f)(fd);
+
+	if (fd_empty(f))
+		return -EBADF;
+	sock = sock_from_file(fd_file(f));
+	if (unlikely(!sock))
+		return -ENOTSOCK;
 
 	if (likely(!(flags & MSG_ERRQUEUE))) {
 		err = sock_error(sock->sk);
-		if (err) {
-			datagrams = err;
-			goto out_put;
-		}
+		if (err)
+			return err;
 	}
 
 	entry = mmsg;
@@ -2996,12 +2972,10 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 	}
 
 	if (err == 0)
-		goto out_put;
+		return datagrams;
 
-	if (datagrams == 0) {
-		datagrams = err;
-		goto out_put;
-	}
+	if (datagrams == 0)
+		return err;
 
 	/*
 	 * We may return less entries than requested (vlen) if the
@@ -3016,9 +2990,6 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 		 */
 		WRITE_ONCE(sock->sk->sk_err, -err);
 	}
-out_put:
-	fput_light(sock->file, fput_needed);
-
 	return datagrams;
 }
 
-- 
2.53.0



